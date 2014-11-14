module PageHelper
  def from_site(url_info)
    # .site
    #   %i.fa.fa-arrow-right
    #   - if @url_info.favicon_url
    #     %img.f{:src => @url_info.favicon_url}
    #   %span= @url_info.site
    capture_haml {
      haml_tag '.site' do
        haml_tag 'i.fa.fa-arrow-right'
        if url_info.favicon_url.present?
          haml_tag 'img.f', :src => url_info.favicon_url
        end
        haml_tag 'span', url_info.site
      end
    }
  end

  def url_desc(url_info)
    capture_haml {
      if url_info.desc.present?
        haml_tag '.desc', simple_format(url_info.desc)
      end
    }
  end

  def url_tags(url_info)
    # - if tags_array.present?
    #   .tags
    #     %i.fa.fa-tags
    #     - tags_array.each do |tag|
    #       %span.tag ##{tag}
    capture_haml {
      tags_array = url_info.tags_array
      if tags_array.present?
        haml_tag '.tags' do
          haml_tag 'i.fa.fa-tags'
          tags_array.each do |tag|
            haml_tag 'a.tag', "##{tag}", :href => "/tags/#{tag}"
          end
        end
      end
    }
  end
end