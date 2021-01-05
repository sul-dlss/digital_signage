require 'json'
require 'nokogiri'
require 'time'

module DigitalSignage
  class ExhibitsBoard < IiifBoard
    def self.call
      output = Faraday.get("https://sul-solr.stanford.edu/solr/exhibits-prod/select?rows=1&wt=json&indent=on&fl=title_full_display,iiif_manifest_url_ssi,druid,spotlight_exhibit_slug*,repository_ssim&fq=content_metadata_type_ssim:image&fq=collection:#{random_collection}&sort=random#{rand(10000)}%20desc").body

      data = JSON.parse(output)
      doc = data['response']['docs'].first
      exhibit_slug = doc.select { |k, v| Array(v).first == true && k =~ /spotlight_exhibit_slug/ }.keys.first.sub('spotlight_exhibit_slug_', '').sub('_bsi', '')
      exhibit_url="https://exhibits.stanford.edu/#{exhibit_slug}"
      catalog_url="#{exhibit_url}/catalog/#{doc['druid']}"
      exhibit_html = Nokogiri::HTML.parse(Faraday.get(exhibit_url).body)
      exhibit_title = exhibit_html.xpath('//meta[@property="og:title"]').first['content'] rescue nil

      iiif_manifest = doc['iiif_manifest_url_ssi']
      hash = extract(iiif_manifest)

      telemetry(hash.merge(
        iiif_title: { text: exhibit_title },
        iiif_description: { text: hash[:iiif_title][:text] },
        iiif_url: { text: catalog_url },
        iiif_logo: { url: 'http://library.stanford.edu/sites/default/files/styles/150x150/public/image/image/sulair_rosette_72dpi.png' },
        iiif_qrcode: { url: catalog_url },
        iiif_attribution: {
          text: Array(doc['repository_ssim']).first
        }
      ))
    end

    def self.random_collection
      output = Faraday.get("https://sul-solr.stanford.edu/solr/exhibits-prod/select?rows=0&wt=json&json.nl=map&fq=content_metadata_type_ssim:image&facet=true&facet.field=collection&facet.limit=10000").body

      data = JSON.parse(output)
      data['facet_counts']['facet_fields']['collection'].keys.sample
    end
  end
end
