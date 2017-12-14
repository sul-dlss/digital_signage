require 'json'
require 'nokogiri'
require 'time'

module DigitalSignage
  class IiifBoard < Board
    def self.call
      output = Faraday.get("https://sul-solr.stanford.edu/solr/exhibits_prod/select?rows=100&wt=json&indent=on&fl=title_full_display,large_image_url_ssm,full_image_url_ssm,druid,spotlight_exhibit_slug*,repository_ssim&fq=content_metadata_type_ssim:image&sort=timestamp%20desc").body

      data = JSON.parse(output)
      doc = data['response']['docs'].sample
      exhibit_url="https://exhibits.stanford.edu/#{doc.select { |k, v| Array(v).first == true && k =~ /spotlight_exhibit_slug/ }.keys.first.sub('spotlight_exhibit_slug_', '').sub('_bsi', '')}"
      catalog_url="#{exhibit_url}/catalog/#{doc['druid']}"
      exhibit_html = Nokogiri::HTML.parse(Faraday.get(exhibit_url).body)
      exhibit_title = exhibit_html.xpath('//meta[@property="og:title"]').first['content']

      telemetry({
        iiif_title: {
          text: doc['title_full_display'].slice(0,255)
        },
        iiif_exhibit_title: { text: exhibit_title },
        iiif_qrcode: { url: catalog_url },
        iiif_url: { text: catalog_url },
        iiif_image: {
          items: [
            Array(doc['large_image_url_ssm']).map { |x| { url:  x } }
          ]
        },
        iiif_repository: {
          text: Array(doc['repository_ssim']).first
        }
      })
    end
  end
end
