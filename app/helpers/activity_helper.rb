module ActivityHelper

  def obj_icon(activity)
    return "" unless activity.object_type

    if activity.object_type == "User"
      icon = "user.png"
    elsif activity.object_type == "Myfile"
      if activity.object
        icon = "file.png"
        icon = "file_download.png" if activity.description == "file.download_file"
        icon = "file_upload.png" if activity.description == "file.upload_file"
      else
        icon = "file_grey.png"
        icon = "file_download_grey.png" if activity.description == "file.download_file"
        icon = "file_upload_grey.png" if activity.description == "file.upload_file"
      end
    elsif activity.object_type == "Folder"
      icon = activity.object ? "folder.png" : "folder_grey.png"
    elsif activity.object_type == "Group"
      icon = "group.png"
    else
      return ""
    end

    image_tag(icon)
  end

  def obj_text(activity)
    return "" unless activity.object_type
    obj = activity.object

    if activity.object_type == "User"
      text = "#{obj.name} (#{obj.email})"
    elsif activity.object_type == "Myfile"
      text = activity.object ? obj.fullpath : activity.params[:file_path]
    elsif activity.object_type == "Folder"
      text = activity.object ? obj.path : activity.params[:folder_path]
    elsif activity.object_type == "Group"
      text = obj.name
    else
      return ""
    end

    h(text)
  end

  def description(activity)
    tag = "activity.descriptions.#{activity.description}"
    params = activity.params || {}
    params[:default] = activity.description + ":" + params.inspect

    begin
      h(t(tag, params))
    rescue
      h(params[:default])
    end
  end

  def category(activity)
    tag = "activity.categories.#{activity.category}"
    h(t(tag, :default => activity.category))
  end
  
end
