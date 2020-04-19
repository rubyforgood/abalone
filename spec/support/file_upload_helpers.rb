module FileUploadHelpers
  # filenames parameter is either a string for a single file or an array of
  # strings if uploading multiple files
  def upload_file(category, filenames)
    select category, from: 'category'
    attach_file('input_files[]', filenames)
    click_on 'Submit'
  end
end
