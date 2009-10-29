require "csv"
require 'rexml/document'
include REXML
require "settings.rb"

@@results = []


def parse_xmls dir
  Dir.foreach(dir) {|file|
    is_xml= file =~ /.*\.xml/
    if is_xml != nil
      show_progress()

      xmldoc = Document.new(File.new(file))
      result = []
      @@benchmarks.each { |k, v|
        result << XPath.first(xmldoc, v).value()
      }
      @@results << result
    end
  }
end

def show_progress
  print "."
end

def create_csv target="log.csv"
  headers = @@benchmarks.keys

  outfile = File.open(target, 'wb')
  CSV::Writer.generate(outfile) do |csv|
    csv << headers
    @@results.each do |result|
      csv << result
    end
  end
end

if ARGV.length ==0
  print <<EOF
Please run the command with:

ruby cc2csv.rb <logs> <targetfile>

logs : the folder contains the cruisecontrol logs file.
targetfile: the target csv file to be generated

You can change the settings.rb to add more column and values with key/value pair,
where the key is the label, the value is the XPATH 

EOF
  exit 1
end

parse_xmls ARGV[0]
ARGV[1] == nil ? create_csv : create_csv(ARGV[1])




















