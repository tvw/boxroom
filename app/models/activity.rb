class Activity < ActiveRecord::Base
  belongs_to :user
  belongs_to :object, :polymorphic => true, 
                      :foreign_type => "object_type",
                      :foreign_key => "object_id"

  CATEGORIES = [
                :auth,
                :folder,
                :file,
               ]

  serialize :params, Hash

  def object?
    object.nil?
  end
  
  # AuthenticationController
  class << self
    def login(user)
      add(:auth, user, nil,  "auth.login")
    end

    def logout(user)
      add(:auth, user, nil, "auth.logout")
    end

    def failed_login(user_name)
      user = user(user_name)
      add(:auth, user, nil, "auth.failed_login", {:user_name => user_name})
    end
    
    def sent_new_password(user_name, user_email)
      user = user(user_name, user_email)
      add(:auth, user, nil, "auth.sent_new_password.success", {:user_name => user_name, :user_email => user_email})
    end

    def sent_new_password_failed(user_name, user_email)
      user = user(user_name, user_email)
      add(:auth, user, nil, "auth.sent_new_password.failed", {:user_name => user_name, :user_email => user_email})
    end

    def create_admin(user)
      add(:auth, user, nil, "auth.create_admin")
    end
  end


  # FolderController
  class << self
    def create_folder(user, folder)
      add(:folder, user, folder, "folder.create_folder")
    end

    def rename_folder(user, folder, old_folder_path)
      add(:folder, user, folder, "folder.rename_folder", {:old_folder_path => old_folder_path})
    end

    def delete_folder(user, folder)
      add(:folder, user, folder, "folder.delete_folder")
    end

    def list_folder(user, folder)
      add(:folder, user, folder, "folder.list_folder")
    end

    def update_permissions_folder(user, folder)
      add(:folder, user, folder, "folder.update_permissions_folder")
    end
  end


  # FileController
  class << self
    def download_file(user, file)
      add(:file, user, file, "file.download_file")
    end

    def upload_file(user, file)
      add(:file, user, file, "file.upload_file")
    end

    def rename_file(user, file, old_file_path)
      add(:file, user, file, "file.rename_file", {:old_file_path => old_file_path})
    end

    def delete_file(user, file)
      add(:file, user, file, "file.delete_file")
    end
  end


  class << self
    private

    def user(id_or_name, email = nil)
      user = User.find(id_or_name) if id_or_name.class == Fixnum
      user = User.find_by_name(id_or_name) unless user or id_or_name.blank?
      user = User.find_by_email(email) unless user or email.blank?
      user
    end

    def add(category, user, obj, description, params = nil)
      act = self.new

      if user
        params = {} if params.nil?
        params[:user_name] = user.name
        params[:user_email] = user.email
      end
      
      if obj and obj.class == Folder
        params[:folder_path] = obj.path
      end

      if obj and obj.class == Myfile
        params[:file_path] = obj.fullpath
      end

      act.category = category.to_s
      act.user_id = user.id if user
      act.description = description
      act.params = params if params
      if obj
        obj.linked_activities << act
      else
        act.save
      end
    end
  end
end
