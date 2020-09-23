class CreateSexEnum < ActiveRecord::Migration[6.0]
  def up
    create_enum :animal_sex, %w[unknown male female]
  end

  def down
    drop_enum :animal_sex
  end
end
