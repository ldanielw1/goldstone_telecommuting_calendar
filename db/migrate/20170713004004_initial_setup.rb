class InitialSetup < ActiveRecord::Migration[5.0]
  def change

    create_table :users do |t|
      t.string   :name,                            :default => ""
      t.string   :email,                           :default => ""
      t.string   :profile_img,                     :default => ""
      t.boolean  :admin,                           :default => false

      t.string   :user_id,                         :default => ""
    end

  end
end
