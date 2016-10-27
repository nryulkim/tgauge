require 'json'

class Flash
  def initialize(req)
    cookie_hash = req.cookies["_rails_lite_app_flash"]
    @existing = cookie_hash ? JSON.parse(cookie_hash) : {}
    @new = {}
  end

  def [](key)
    merged = @existing.merge(@new)
    merged[key.to_s]
  end

  def []=(key, val)
    if @add_next
      @existing[key.to_s] = val
      @add_next = false
    else
      @new[key.to_s] = val
    end
  end

  def now
    @add_next = true
    self
  end

  def store_flash(res)
    out_cookie = @new.to_json
    res.set_cookie('_rails_lite_app_flash', { path: "/", value: out_cookie })
  end
end
