namespace :refile do
  task :download_files => :environment do

    migration_dir = File.join(Rails.root, 'tmp', 'attachment_migration')
    create_dir(migration_dir)

    models_attributes = {
      Attachment => [:file],
      Competition => [:expected_csv, :ilustration],
      Submission => [:csv],
      Team => [:avatar],
      User => [:avatar]
    }

    models_attributes.each do |model, attributes|

      3.times { puts ('') }
      puts ("=" * 32)
      puts "Processando #{model.model_name.plural}"
      puts ("=" * 32)

      model_dir = File.join(migration_dir, model.model_name.plural)
      create_dir(model_dir)
      attributes.each do |attribute|

        puts ("-" * 32)
        puts "Processando #{attribute}"
        puts ("-" * 32)

        attr_dir = File.join(model_dir, attribute.to_s)
        create_dir(attr_dir)
        model.find_each do |record|
          puts "#{model.model_name.plural}/#{record.id}/#{attribute}"
          next if record.send(attribute).nil?
          dir = File.join(attr_dir, "#{record.id}")
          path = File.join(dir, extract_filename(record, attribute))
          create_dir(dir)
          File.binwrite(path, record.send(attribute).read)
        end
      end
    end
  end

  def create_dir(dir)
    Dir.mkdir(dir) unless Dir.exist?(dir)
  end

  # If the filename does not contain the extension, try to guess it
  def extract_filename(record, attribute)
    filename = record.send("#{attribute}_filename".to_sym)
    content_type = record.send("#{attribute}_content_type".to_sym)
    # Filename does not end in .png or .jpg or .jpeg
    if (filename =~ /.png\z|\.jpe?g\z/).nil?
      case content_type
      when 'image/jpeg'
        filename += '.jpeg'
      when 'image/png'
        filename += '.png'
      end
    end
    filename
  end
end
