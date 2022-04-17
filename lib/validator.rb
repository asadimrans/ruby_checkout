module Validator

  def validates_presence file
    raise 'Please, provide a valid path of the file!!!' unless File.exists?(file || '')
  end

  def validates_content_type file, whitelist_attr
      raise 'Please, provide a valid file!!!' unless whitelist_attr.include?(File.extname(file))
  end
end
