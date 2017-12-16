require 'spec_helper'

RSpec.describe DigitalSignage::IiifBoard do
  it 'extracts digital signage content from a iiif manifest' do
    data = described_class.extract(iiif_manifest: 'https://purl.stanford.edu/cj367yz5130/iiif/manifest')

    expect(data).to include iiif_title: { text: starting_with('Cometo-Scopia') },
                            iiif_description: { text: starting_with('Charts') },
                            iiif_attribution: { text: starting_with('To obtain permission to publish') },
                            iiif_logo: { url: starting_with('https://stacks.stanford.edu') },
                            iiif_image: { items: include(url: starting_with('https://stacks.stanford.edu/image/iiif/cj367yz5130%2Fcj367yz5130_00_0005')) },
                            iiif_image_label: { items: include(text: 'Image 1') }
  end
end
