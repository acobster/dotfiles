# Audio Tools

## `wpctl`
WirePlumber control CLI. Used to inspect and control PipeWire devices, sources, sinks, and volumes (e.g. `wpctl status`, `wpctl set-volume`, `wpctl inspect`).

## `pw-cli`
Low-level PipeWire CLI. Lets you directly enumerate and set parameters on PipeWire objects, including switching Bluetooth audio profiles via `enum-params` / `set-param`.

## `pactl`
PulseAudio control CLI (from the `pulseaudio` package). Works with PipeWire via its PulseAudio compatibility layer. Used to switch Bluetooth card profiles (e.g. A2DP ↔ HFP) and inspect cards/sources.

## `bluetoothctl`
BlueZ Bluetooth control CLI. Used to inspect paired devices, check connection status, and see supported UUIDs (profiles).

## `alsamixer`
ALSA TUI mixer. Can expose low-level hardware capture controls (like mic boost) that higher-level tools don't always surface.

## `dbus-send`
General D-Bus message tool. Used here to query BlueZ directly for active media transport info (codec, volume, state) that isn't exposed by the audio stack tools.
