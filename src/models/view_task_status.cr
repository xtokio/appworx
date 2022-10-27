module Model
  class ViewTaskStatus < Crecto::Model

    schema "view_task_status" do # table name
      field :id, Int32, primary_key: true
      field :job_id, Int32
      field :task_id, Int32
      field :status, String
      field :response, String
      field :job, String
      field :task, String
      field :description, String
      field :language, String
      field :command, String
    end
    
  end
end