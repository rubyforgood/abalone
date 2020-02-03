module FileUploadHelpers

  def upload_file(category, filename)
    select category, from: 'category'
    attach_file('input_file', Rails.root + filename)
    click_on 'Submit'
  end

end
