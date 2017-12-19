require 'json'
require 'nokogiri'
require 'time'

module DigitalSignage
  class IiifBoard < Board
    def self.call(iiif_manifest:)
      telemetry(
        extract(iiif_manifest)
      )
    end

    def self.extract(iiif_manifest)
      response = Faraday.get(iiif_manifest)
      data = JSON.parse(response.body)

      {
        iiif_title: { text: data['label'] },
        iiif_description: { text: data['description'] },
        iiif_attribution: { text: data['attribution'] },
        iiif_logo: { url: data['logo']['@id'] },
        iiif_image: {
          items: data['sequences'].map { |seq| seq['canvases'].map { |can| can['images'].map { |img| img['resource']['service']['@id'] }.first } }.flatten.map { |id| { url: "#{id}/full/!2000,950/0/default.jpg" } }
        },
        iiif_image_label: {
          items: data['sequences'].map { |seq| seq['canvases'].map { |can| can['label'] } }.flatten.map { |label| { text: "#{label}" } }
        }
      }
    end
  end
end
