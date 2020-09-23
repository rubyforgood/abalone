module FileUploadsHelper
  def file_upload_status_style(status)
    if status.include? '0 records had errors'
      'fa fa-check has-text-success'
    elsif status.include? 'Pending'
      ''
    elsif status.match /[1-9]\d* records had errors/
      'fas fa-exclamation-triangle has-text-danger'
    end
  end
end
