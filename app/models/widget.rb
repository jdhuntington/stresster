require 'digest/md5'
require 'base64'

class Widget < ActiveRecord::Base
  before_create :set_key

  def self.from_scratch!
    f = File.open('/dev/urandom', 'r')
    data = Base64.encode64(f.read(1024))
    f.close
    create!(:data => data)
  end

  def generate_key
    x = nil
    100.times do
      x = Digest::MD5.hexdigest(data)
    end
    x
  end
  
  private
  def set_key
    self.key = generate_key
  end
end
