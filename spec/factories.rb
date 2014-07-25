FactoryGirl.define do
  factory :token, class: OauthToken do
    access_token "21l_2i1Ofji-7d_MWyc25Q"
    refresh_token "Z5ZU5DlYQlcPIa2pBopimQ" 
    user_attributes "{\"name\":\"Bob\"}" 
  end
end