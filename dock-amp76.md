# Dock Multi-Monitor Debugging

## Problem

On a amp76, a System76 Lemur Pro (Intel Meteor Lake-P, kernel 7.0.11-76070011), connecting a second HDMI monitor to a **Mokin MOUC0304** USB-C dock caused:
- Both external monitors to flash black repeatedly
- The new monitor never displaying an image (amber indicator light)
- After disconnecting the HDMI cable, the HP monitor also going dead until the dock was fully replugged

The dock and cable were verified working on another laptop (KDE, different hardware).

## Hardware

- **GPU**: Intel Meteor Lake-P (device ID 7d45, Display engine 14.00, stepping C0)
- **Dock**: Mokin MOUC0304 — USB-C Alt Mode dock (not Thunderbolt)
- **Monitors**: HP 27xw (via dock) + second HDMI monitor (via dock HDMI port) + laptop built-in (TMA 1920x1200)

## Diagnostics

### syslog during hotplug (`monitor.log`)

Relevant output:
```
(II) modeset(0): Allocate new frame buffer 5760x1200 stride   ← all 3 displays seen briefly
(EE) modeset(0): failed to set mode: No such file or directory
(WW) modeset(0): hotplug event: connector 507's link-state is BAD
(WW) modeset(0): hotplug event: connector 555's link-state is BAD
kernel: i915 0000:00:02.0: [drm] *ERROR* Failed to get ACT after 3000 ms, last status: 00
(II) modeset(0): Allocate new frame buffer 1920x1200 stride    ← collapses back to 1 display
Monitor 'Hewlett Packard 27"' has no configuration which is-current!
```

**Conclusion**: The i915 driver failed DP MST ACT (Action Change Trigger) negotiation when trying to add a second MST stream. The dock's MST hub never acknowledged the payload allocation.

### dmesg (`dmesg.log`)

```
i915 0000:00:02.0: [drm] Found meteorlake/u (device ID 7d45) integrated display version 14.00
i915 0000:00:02.0: [drm] *ERROR* GT1: GSC proxy component didn't bind within the expected timeout
i915 0000:00:02.0: [drm] *ERROR* GT1: GSC proxy handler failed to init
i915 0000:00:02.0: [drm] *ERROR* Failed to get ACT after 3000 ms, last status: 00  ← repeated 4×
```

**Conclusion**: GSC (Graphics Security Controller) proxy fails to initialize at boot — a known Meteor Lake issue. ACT failures confirm MST negotiation is broken at the kernel level.

### Dock connection type

```sh
sudo dmesg | grep -iE 'thunderbolt|tbt|usb4|typec|ucsi|altmode'
```

No Thunderbolt device entries. Dock USB hub appears on Bus 3 at USB 2.0 high-speed (480 Mbps), meaning the dock uses **DP4 Alt Mode** (all 4 USB-C lanes for DisplayPort, USB 2.0 for data). No Thunderbolt negotiation occurs.

```sh
lsusb | grep -v 'Linux Foundation\|root hub'
# Only shows: Terminus Technology Hub, Logitech peripherals, laptop webcam/BT
```

**Conclusion**: The dock has no DisplayLink or other USB display chip. It is a pure USB-C DP Alt Mode dock, not a Thunderbolt device.

### After switching to `xe` driver (`monitor-xe.log`)

Switching drivers (`i915.force_probe=!7d45 xe.force_probe=7d45`) made the new monitor detect the cable (indicator light amber → white), but the failure mode continued:

```
gnome-shell: Page flip failed: drmModeAtomicCommit: Invalid argument   ← repeated
xe 0000:00:02.0: [drm] *ERROR* Failed to get ACT after 3000 ms, last status: 00
xe 0000:00:02.0: [drm] *ERROR* Failed to read DPCD register 0x92       ← DP AUX comm lost
kernel: usb 3-3: USB disconnect, device number 8                        ← dock power-cycles
kernel: usb 3-3.1: USB disconnect, device number 9
kernel: usb 3-3.3: USB disconnect, device number 10
kernel: usb 3-3.4: USB disconnect, device number 11
```

**Conclusion**: The ACT timeout causes the dock's MST hub to reset entirely, disconnecting all USB devices (explaining why the HP monitor also dies). The bug is in the shared Meteor Lake MST implementation, not the i915/xe wrapper.

## Things That Did Not Help

| Attempt | Result |
|---|---|
| `i915.enable_psr=0` (disable Panel Self Refresh) | No change |
| Switch to GNOME Wayland | No change |
| Switch to `xe` driver | Monitor detected, same ACT failure |

## Root Cause

The Mokin MOUC0304 is a USB-C Alt Mode dock whose MST hub chip is incompatible with Intel Meteor Lake's display engine. When a second external display is added, the driver fails to complete DP MST ACT negotiation (`last status: 00` = hub never acknowledges the stream allocation), causing the dock to power-cycle and drop all displays.

This is a kernel-level bug — reproducible on both i915 and xe drivers. The same dock works on non-Meteor Lake hardware.

## Workaround

Connect the second external monitor to the **laptop's built-in HDMI port** directly. The dock drives the HP monitor (one MST stream), the HDMI port drives the second monitor independently. No MST negotiation required.

## Recommendations for a Better Dock

**Best fix**: Replace the dock with a **Thunderbolt 4 certified** dock. TBT4 docks tunnel display data through the Thunderbolt protocol rather than raw DP Alt Mode, bypassing the MST hub incompatibility. The Lemur Pro has two TBT controllers (`TBT0`/`TBT1` in ACPI).

- Look for: **"Intel Thunderbolt 4 Certified"** badge specifically (not just "USB-C" or "USB4")
- CalDigit and OWC have strong Linux compatibility reputations (CalDigit TS4 frequently cited)
- Prefer DP outputs over HDMI on the dock

**Alternative**: A **DisplayLink dock** routes video over USB entirely, bypassing the GPU's MST engine. Requires the `evdi` kernel module; Wayland support is much improved in recent kernels but adds a dependency.

**Avoid**: Any dock marketed as "USB-C docking station" without explicit Thunderbolt 4 branding — these all use the same USB-C DP Alt Mode + MST hub approach and will hit variants of this issue on Meteor Lake.
