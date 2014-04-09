require 'spec_helper'

describe UrlInfo do
  before :all do
    @user_store = UserStore.create(
      secret: 'b8da7970fc17f50b8f5be2df1b5f6bb4',
      uid:    '1111',
      name:   'test',
      email:  'test@test.com',
      avatar: 'http://xxx.jpg'
    )
  end

  it{
    @user_store.url_infos.count.should == 0
    url_info = @user_store.url_infos.create(:url => "http://www.baidu.com", :title => "test")
    url_info.valid?.should == true
    url_info.short_url.blank?.should == false
  }
end