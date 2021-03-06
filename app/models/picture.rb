class Picture < ActiveRecord::Base

  belongs_to :user

  # TODO: add validations

  has_attached_file :photo,
                    styles: { standard: '960x960>', quarter: '480x480>' },
                    storage: :s3,
                    s3_permissions: 'authenticated-read',
                    s3_credentials: {
                        access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                        secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
                    }, # File.join(Rails.root, 'config', 's3.yml'),
                    url: ':s3_domain_url',
                    path: '/assets/:class/:id/:style.:extension',
                    s3_server_side_encryption: :aes256,
                    s3_host_name: 's3-eu-west-1.amazonaws.com',
                    bucket: ENV['AWS_BUCKET']

  validates_attachment_content_type :photo, :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

  def url(style = :standard)
    Paperclip::Interpolations.interpolate('/:class/:id/:style.:extension', photo, style)
  end

  def authenticated_url(style = :standard)
    photo.expiring_url(60, style)
  end

end
