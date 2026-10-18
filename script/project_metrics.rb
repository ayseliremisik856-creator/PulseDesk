# Small reproducible inventory; physical lines include comments and blank lines.
# This does not measure proprietary Zendesk code or infer development effort.
require "json"

files = Dir.glob("{app,lib}/**/*").select do |path|
  File.file?(path) && %w[.rb .erb .js .css].include?(File.extname(path))
end.sort
counts = files.group_by { |path| File.extname(path) }.transform_values do |paths|
  { files: paths.size, physical_lines: paths.sum { |path| File.foreach(path).count } }
end
puts JSON.pretty_generate(scope: "app/ and lib/; rb, erb, js, css; no dependencies, tests or generated schema", by_extension: counts, physical_lines: counts.values.sum { |entry| entry[:physical_lines] })
