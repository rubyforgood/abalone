module FileUploadsHelper
  def file_upload_status_style(status)
    if success? status
      'fa fa-check has-text-success'
    elsif pending? status
      'fas fa-spinner'
    elsif failed? status
      'fas fa-exclamation-triangle has-text-danger'
    end
  end

  def success?(status)
    status.include?('0 records had errors') || status == 'Processed'
  end

  def pending?(status)
    status.include?('Pending') || status == 'Running'
  end

  def failed?(status)
    status == 'Failed' || status.match(/[1-9]\d* records had errors/)
  end
end
