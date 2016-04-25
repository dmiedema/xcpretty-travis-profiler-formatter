# XCPretty Travis Profiler Formatter

Custom formatter for [xcpretty](https://github.com/supermarin/xcpretty) that calculates the compile time for files in Xcode projects and prints them to `stdout` formatted for Travis.

## Installation

Run:

```
gem install xcpretty-travis-profiler-formatter
```

## Usage

Specify `xcpretty-travis-profiler-formatter` as a custom formatter to `xcpretty`:

```bash
#!/bin/bash

xcodebuild -project "Project.xcodeproj" clean build | xcpretty -f `xcpretty-travis-profiler-formatter`
```

## Sample output

```
xcodebuild -workspace BrightFutures.xcworkspace -scheme BrightFutures-iOS clean build | xcpretty -f `xcpretty-travis-profiler-formatter`

[...]

[0.2616] Source/BrightFutures/BrightFutures/Async.swift
[1.0931] Source/BrightFutures/Carthage/Checkouts/Result/Result/ResultType.swift
[1.1641] Source/BrightFutures/BrightFutures/Errors.swift
[1.1724] Source/BrightFutures/BrightFutures/Errors.swift
[1.7121] Source/BrightFutures/Carthage/Checkouts/Result/Result/ResultType.swift
-----
[7.4310] Total compilation time
```

## Author

* Lars Lockefeer ([@larslockefeer](https://twitter.com/larslockefeer))
* Modified by Daniel Miedema ([@no_good_ones](https://twitter.com/no_good_ones))
