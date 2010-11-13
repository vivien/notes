# ------------------------------------------------------------------------------
# "THE BEER-WARE LICENSE" (Revision 42):
# <vivien.didelot@gmail.com> wrote this file. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and you
# think this stuff is worth it, you can buy me a beer in return. Vivien Didelot
# ------------------------------------------------------------------------------

# Useless, but informs that rak should be installed.
require 'rubygems'
require 'rak'

module Notes
  class Reader
    attr_reader :list, :target

    def initialize(target = nil)
      @target = Array.new
      @target.push(target).flatten! unless target.nil?
    end

    def find(tags = TAGS)
      tags = [tags] unless tags.is_a? Array

      cmd = "rak " << "'#{tags * "|"}' " << @target * " "
      out = `#{cmd}`.strip
      raise out if $?.exitstatus > 0

      # Because of different rak versions,
      # rak system call outputs are not similar.
      if `rak --version` =~ /rak (\d\.\d)/
        rak_version = $1
      else
        raise "Can't get rak version"
      end

      # 0.9 is the current rak gem version.
      # 1.1 is the rak version from the github repo.
      if rak_version == "1.1"
        regex = /^(.*):(\d*):.*(#{tags * "|"})\s*(.*)$/
      else
        regex = /^([^\s]+)\s+(\d+)\|.*(#{tags * "|"})\s*(.*)$/
      end

      @list = out.split("\n").map do |l|
        if l =~ regex
          Annotation.new({
            :file => $1,
            :line => $2.to_i,
            :tag => $3,
            :text => $4.strip
          })
        else
          # Just for a debug purpose
          raise "notes: does not match regexp => \"#{l}\""
        end
      end
    end

    def get(tag)
      res = @list.find_all { |a| a.tag == tag }
      res.empty? ? nil : res
    end

    def write(file)
      longest_tag = @list.max { |a, b| a.tag.size <=> b.tag.size }.tag.size

      File.open(file, 'w') do |f|
        @list.each do |a|
          f.write(sprintf(" * [%-#{longest_tag}s] %s (%s): %s\n",
                          a.tag, a.file, a.line, a.text))
        end
      end
    end
  end
end
