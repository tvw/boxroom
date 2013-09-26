# A folder is a place where files can be stored.
# Folders can also have sub-folders.
# Via groups it is determined which actions the logged-in User can perform.
class Folder < ActiveRecord::Base
  acts_as_tree :order => 'name'

  belongs_to :user
  has_many :myfiles, :dependent => :destroy
  has_many :group_permissions, :dependent => :destroy
  has_many :linked_activities, :as => :object, :class_name => "Activity"

  validates_uniqueness_of :name, :scope => 'parent_id'
  validates_presence_of :name

  attr_accessible :name

  # List subfolders
  # for the given user in the given order.
  def list_subfolders(logged_in_user, order)
    folders = []
    if logged_in_user.can_read(self.id)
      self.children.find(:all, :order => order).each do |sub_folder|
        folders << sub_folder if logged_in_user.can_read(sub_folder.id)
      end
    end

    # return the folders:
    return folders
  end

  # List the files
  # for the given user in the given order.
  def list_files(logged_in_user, order)
    files = []
    if logged_in_user.can_read(self.id)
      files = self.myfiles.find(:all, :order => order)
    end

    # return the files:
    return files
  end

  # List of users who can read the folder
  def list_users_who_can_read
    User.find(:all, :order => "name").select{|user| user.can_read(self.id)}
  end

  # Folders readable by user
  def self.folders_readable_by_user(user, root_folder = Folder.find_by_is_root(true))
    Folder.find(:all).select{|f| user.can_read(f.id)}.sort{|a,b| a.path <=> b.path }
  end

  # The path of the folder
  def path
    if is_root?
      name
    else
      [parent.path, name].join("/")
    end
  end

  # Returns whether or not the root folder exists
  def self.root_folder_exists?
    folder = Folder.find_by_is_root(true)
    return (not folder.blank?)
  end

  # Create the Root folder
  def self.create_root_folder
    if User.admin_exists? #and  Folder.root_folder_exists?
      folder = self.new
      folder.name = 'Root folder'
      folder.date_modified = Time.now
      folder.is_root = true

      # This folder is created by the admin
      if user = User.find_by_is_the_administrator(true)
        folder.user = user
      end

      folder.save # this hopefully returns true
    end
  end
end
