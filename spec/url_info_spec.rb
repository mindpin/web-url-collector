require 'spec_helper'

describe UrlInfo do
  before do
    @secret = 'a8da7970fc17f50b8f5be2df1b5f6bb5'
    @user_store = UserStore.create(
      secret: @secret,
      uid:    '9479',
      name:   'mindpin_test',
      email:  'test@mindpin.com',
      avatar: 'http://4ye.mindpin.com/assets/default_avatars/normal.png'
    )
  end

  it{
    @user_store.url_infos.count.should == 0
    url_info = @user_store.url_infos.create(:url => "http://www.baidu.com", :title => "test")
    url_info.valid?.should == true
    url_info.short_url.blank?.should == false
    url_info.add_tags("a,b,c").should == ["a","b","c"]
    url_info.tags_array.should == ["a", "b", "c"]
  }

  it{
    hash = {
      secret: @secret,
      url: "http://www.baidu.com",
      title: "百度一下你就知道",
      desc: "传说中的度娘",
      image_url: "",
      tags: "搜索,入口"
    }
    post "/collect_url", hash
    res = JSON.parse(last_response.body)
    url_info = UrlInfo.last
    res.should == {
      "url"=>"http://www.baidu.com", 
      "short_url"=>"http://s.4ye.me/D8MIdn", 
      "title"=>"百度一下你就知道", 
      "desc"=>"传说中的度娘", 
      "image_url"=>"", 
      "tags"=>["搜索", "入口"], 
      "user_id"=>"9479", 
      "user_name"=>"mindpin_test",
      "site_url" => "http://collect.4ye.me/url_infos/#{url_info.id}"
    }

    hash_change = {
      secret: @secret,
      url: "http://www.baidu.com",
      title: "百度一下你就知道1",
      desc: "传说中的度娘1",
      image_url: "",
      tags: "a,b",
      update: true
    }
    post "/collect_url", hash_change
    res = JSON.parse(last_response.body)
    url_info_change = UrlInfo.where(url: "http://www.baidu.com").first
    url_info_change.id.should == url_info.id
    url_info_change.title.should == "百度一下你就知道1"
    res.should == {
      "url"=>"http://www.baidu.com", 
      "short_url"=>"http://s.4ye.me/D8MIdn", 
      "title"=>"百度一下你就知道1", 
      "desc"=>"传说中的度娘1", 
      "image_url"=>"", 
      "tags"=>["a", "b"], 
      "user_id"=>"9479", 
      "user_name"=>"mindpin_test",
      "site_url" => "http://collect.4ye.me/url_infos/#{url_info_change.id}"
    }

    hash_error = {
      secret: "abc"
    }
    post "/collect_url", hash_error
    res = JSON.parse(last_response.body)
    res.should == {"status"=>"error", "info"=>"undefined method `url_infos' for nil:NilClass"}


    check_hash = {
      secret: @secret,
      url: "http://www.baidu.com"
    }
    get "/check_url", check_hash
    res = JSON.parse(last_response.body)
    url_info = UrlInfo.last
    res.should == {
      "collected"=>true, 
      "data"=>{
        "url"=>"http://www.baidu.com", 
        "short_url"=>"http://s.4ye.me/D8MIdn", 
        "title"=>"百度一下你就知道1", 
        "desc"=>"传说中的度娘1", 
        "image_url"=>"", 
        "tags"=>["a", "b"], 
        "user_id"=>"9479", 
        "user_name"=>"mindpin_test", 
        "site_url"=>"http://collect.4ye.me/url_infos/#{url_info.id}"
      }
    }

    check_hash_unexist = {
      secret: @secret,
      url: "http://www.baidu.com123"
    }
    get "/check_url", check_hash_unexist
    res = JSON.parse(last_response.body)
    url_info = UrlInfo.last
    res.should == {
      "collected"=>false, 
      "data"=>{
        "url"=>"http://www.baidu.com123", 
        "short_url"=>"http://s.4ye.me/DSFH3m"
      }
    }

    check_hash_unexist = {
      secret: 11111
    }
    get "/check_url", check_hash_unexist
    res = JSON.parse(last_response.body)
    res.should == {"status"=>"error", "info"=>"undefined method `url_infos' for nil:NilClass"}
  }
end