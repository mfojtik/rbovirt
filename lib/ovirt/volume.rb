module OVIRT

  class Volume < BaseObject
    attr_reader :size, :disk_type, :bootable, :interface, :format, :sparse, :storage_domain, :vm

    def initialize(client, xml)
      super(client, xml[:id], xml[:href], (xml/'name').first.text)
      parse_xml_attributes!(xml)
      self
    end

    def self.to_xml(storage_domain_id,opts={})
       builder = Nokogiri::XML::Builder.new do
        disk_{
          storage_domains_{
            storage_domain_(:id => storage_domain_id)
          }
          size_(opts[:size] || 8589934592)
          type_(opts[:type] || 'system')
          bootable_(opts[:bootable] || 'true')
          interface_(opts[:interface] || 'virtio')
          format_(opts[:format] || 'cow')
          sparse_(opts[:sparse] || 'true')
        }
      end
      Nokogiri::XML(builder.to_xml).root.to_s
    end

    def parse_xml_attributes!(xml)
     @storage_domain = (xml/'storage_domains/storage_domain').first[:id]
     @size = (xml/'size').first.text
     @disk_type = (xml/'type').first.text
     @bootable = (xml/'bootable').first.text
     @interface = (xml/'interface').first.text
     @format = (xml/'format').first.text
     @sparse = (xml/'sparse').first.text
     @vm = Link::new(@client, (xml/'vm').first[:id], (xml/'vm').first[:href])
    end

  end
end