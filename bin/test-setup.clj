#!/usr/bin/env bb

;; test the current environment, asserting that basic commands work

(require
  '[babashka.classpath :refer [add-classpath]]
  '[clojure.java.shell :refer [sh]]
  '[clojure.test :refer [deftest is run-tests]])

(deftest test-php
  (let [{out :out} (sh "php" "-r" "echo 'hello, world!';")]
    (is (= "hello, world!" out))))

(run-tests)

(println "\nbabashka works!\n")
