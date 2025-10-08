# XCSize

A Ruby gem to profile iOS and macOS app and framework sizes from linkmap files, providing detailed breakdowns and insights.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'xcsize'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install xcsize
```

## Usage

### Profile a single linkmap

```bash
xcsize profile --linkmap path/to/your/linkmap.txt
```

Options:
- `--linkmap STRING` - Linkmap file path
- `--threshold BYTES` - Minimum size threshold in bytes (default: 0)

### Compare two linkmaps

```bash
xcsize compare --old-linkmap old_linkmap.txt --new-linkmap new_linkmap.txt
```

Options:
- `--old-linkmap STRING` - Old linkmap file path
- `--new-linkmap STRING` - New linkmap file path
- `--threshold BYTES` - Minimum size threshold in bytes (default: 0)

## [fastlane](https://github.com/fastlane/fastlane) integration

To get started with [xcsize fastlane plugin](https://github.com/testableapple/fastlane-plugin-xcsize), add it to your project by running:

```bash
fastlane add_plugin xcsize
```

### Usage

```ruby
lane :test do
  xcsize(linkmap: 'path/to/your/linkmap.txt')

  xcsize_diff(old_linkmap: 'path/to/your/old_linkmap.txt', new_linkmap: 'path/to/your/new_linkmap.txt')
end
```

## License

This project is licensed under the terms of the MIT license. See the [LICENSE](LICENSE) file.
