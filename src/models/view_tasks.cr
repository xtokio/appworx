module Model
  class ViewTask < Crecto::Model

    schema "view_tasks" do # table name
      field :id, Int32, primary_key: true
      field :job_id, Int32
      field :job, String
      field :task, String
      field :description, String
      field :language, String
      field :command, String
      field :active, Int32
    end
    
  end
end