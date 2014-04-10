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
    url_info.add_tags(@secret, "a,b,c").should == ["a","b","c"]
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
    res.should == {
      "url"=>"http://www.baidu.com", 
      "short_url"=>"http://s.4ye.me/D8MIdn", 
      "title"=>"百度一下你就知道", 
      "desc"=>"传说中的度娘", 
      "image_url"=>"", 
      "tags"=>["搜索", "入口"], 
      "user_id"=>"9479", 
      "user_name"=>"mindpin_test"
    }
  }
end