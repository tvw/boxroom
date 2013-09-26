require 'fileutils'
require 'zip/zipfilesystem'

# Files in the database are represented by Myfile.
# It's called Myfile, because File is a reserved word.
# Files are in (belong to) a folder and are uploaded by (belong to) a User.
class Myfile < ActiveRecord::Base
  belongs_to :folder
  belongs_to :user

  has_many :usages, :dependent => :destroy
  has_many :linked_activities, :as => :object, :class_name => "Activity"

  validates_uniqueness_of :filename, :scope => 'folder_id'

  # Full path of the file: folder path and filename.
  def fullpath
    [folder.path, filename].join("/")
  end

  # Validate if the user's data is valid.
  def validate
    if self.filename.blank?
      errors.add(:filename, " can't blank.")
    end
  end

  # Accessor that receives the data from the form in the view.
  # The file will be saved in a folder called 'uploads'.
  # (See: AWDWR pp. 362.)
  def myfile=(myfile_field)
    if myfile_field and myfile_field.length > 0
      # Get the filename
      filename = Myfile.base_part_of(myfile_field['filename'])

      # Set date_time_created,
      # this will be the files temporary name.
      # (this instance variable is also used in temp_path)
      @date_time_created = Time.now.to_f

      # Save the file on the file system
      begin
        FileUtils.mv(myfile_field['path'], self.temp_path)
        RAILS_DEFAULT_LOGGER.debug("moved '#{myfile_field['path']}' to '#{self.temp_path}'")
      rescue
        FileUtils.cp(myfile_field['path'], self.temp_path)
        RAILS_DEFAULT_LOGGER.debug("copied '#{myfile_field['path']}' to '#{self.temp_path}'")
      end
      FileUtils.chmod(0644, self.temp_path)

      # Save it all to the database
      self.filename = filename
      filesize = (File.size(self.temp_path) / 1000).to_i
      if filesize == 0
        self.filesize = 1 # a file of 0 KB doesn't make sense
      else
        self.filesize = filesize
      end
    end
  end

  attr_writer :text # Setter for text

  # Getter for text.
  # If text is blank get the text from the index.
  def text
    @text = "" if @text.blank?
    @text
  end

  after_create :rename_newfile
  # The file in the uploads folder has the same name as the id of the file.
  # This must be done after_create, because the id won't be available any earlier.
  def rename_newfile
    File.rename self.temp_path, self.path
  end

  before_destroy :delete_file_on_disk
  # When removing a myfile record from the database,
  # the actual file on disk has to be removed too.
  # That is exactly what this method does.
  def delete_file_on_disk
    File.delete self.path
  end

  # Strip of the path and replace all the non alphanumeric,
  # underscores and periods in the filename with an underscore.
  def self.base_part_of(file_name)
    # NOTE: File.basename doesn't work right with Windows paths on Unix
    # INCORRECT: just_filename = File.basename(file_name.gsub('\\\\', '/')) 
    # get only the filename, not the whole path
    name = file_name.gsub(/^.*(\\|\/)/, '')

    # finally, replace all non alphanumeric, underscore or periods with underscore
    name.gsub(/[^\w\.\-]/, '_') 
  end

  # Returns the location of the file before it's saved
  def temp_path
    "#{UPLOAD_PATH}/#{@date_time_created}"
  end

  # The path of the file
  def path
    "#{UPLOAD_PATH}/#{self.id}"
  end
end
