#!/usr/bin/env ruby
# frozen_string_literal: true

require 'date'
require 'set'
require 'uri'
require 'yaml'

ROOT = File.expand_path('..', __dir__)
DATA_DIR = File.join(ROOT, '_data')
ENTRIES_DIR = File.join(ROOT, '_senshu')

FIELD_TO_DATA = {
  'phase' => 'phases',
  'target_os' => 'target_os',
  'services' => 'services',
  'techniques' => 'techniques',
  'items' => 'items'
}.freeze

REQUIRED_FIELDS = %w[description phase target_os references].freeze
NON_EMPTY_FIELDS = %w[description phase references].freeze

def load_ids(name)
  path = File.join(DATA_DIR, "#{name}.yml")
  YAML.load_file(path).map { |item| item.fetch('id') }.to_set
end

def front_matter(path)
  content = File.read(path)
  match = content.match(/\A---\s*\n(.*?)\n---\s*(?:\n|\z)/m)
  raise 'missing YAML front matter' unless match

  YAML.safe_load(match[1], permitted_classes: [Date], aliases: true) || {}
end

def valid_url?(value)
  uri = URI.parse(value.to_s)
  uri.is_a?(URI::HTTP) && !uri.host.nil?
rescue URI::InvalidURIError
  false
end

valid_ids = FIELD_TO_DATA.values.uniq.to_h { |name| [name, load_ids(name)] }
errors = []

Dir[File.join(ENTRIES_DIR, '*.md')].sort.each do |path|
  entry = front_matter(path)

  REQUIRED_FIELDS.each do |field|
    value = entry[field]
    errors << "#{path}: missing #{field}" unless entry.key?(field)
    if NON_EMPTY_FIELDS.include?(field) && (value.nil? || (value.respond_to?(:empty?) && value.empty?))
      errors << "#{path}: #{field} must not be empty"
    end
  end

  has_command = entry.key?('command')
  has_commands = entry.key?('commands')
  if has_command == has_commands
    errors << "#{path}: define exactly one of command or commands"
  end

  if has_command && entry['command'].to_s.strip.empty?
    errors << "#{path}: command must not be empty"
  end

  if has_commands
    unless entry['commands'].is_a?(Array) && !entry['commands'].empty?
      errors << "#{path}: commands must be a non-empty array"
    end

    Array(entry['commands']).each_with_index do |block, index|
      unless block.is_a?(Hash)
        errors << "#{path}: commands[#{index}] must be a map"
        next
      end

      have = block['have']
      cmd = block['cmd']
      errors << "#{path}: commands[#{index}].have is required" if have.to_s.strip.empty?
      errors << "#{path}: commands[#{index}].cmd is required" if cmd.to_s.strip.empty?
      unless have.to_s.empty? || valid_ids['items'].include?(have)
        errors << "#{path}: commands[#{index}].have has invalid item #{have.inspect}"
      end
    end
  end

  FIELD_TO_DATA.each do |field, data_name|
    next if field == 'items' && has_commands

    values = Array(entry[field])
    unless entry.key?(field)
      errors << "#{path}: missing #{field}"
      next
    end

    values.each do |value|
      next if valid_ids[data_name].include?(value)

      errors << "#{path}: #{field} has invalid value #{value.inspect}"
    end
  end

  Array(entry['references']).each do |reference|
    errors << "#{path}: invalid reference URL #{reference.inspect}" unless valid_url?(reference)
  end
rescue StandardError => e
  errors << "#{path}: #{e.message}"
end

if errors.empty?
  puts "Validated #{Dir[File.join(ENTRIES_DIR, '*.md')].count} entries."
else
  warn errors.join("\n")
  exit 1
end
