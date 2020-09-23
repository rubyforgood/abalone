class MigrateAnimalSexToPostgresEnum < ActiveRecord::Migration[6.0]
  def up
    execute <<-DDL
      ALTER TABLE animals ALTER COLUMN sex TYPE animal_sex
      USING CASE sex
        WHEN 'male' THEN 'male'::animal_sex
        WHEN 'female' THEN 'female'::animal_sex
        WHEN NULL THEN 'unknown'::animal_sex
      END;
      ALTER TABLE animals ALTER COLUMN sex SET NOT NULL
    DDL
  end
end
