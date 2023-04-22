module Model
  class ViewJobStatus < Crecto::Model
    schema "view_job_status" do # table name
      field :id, Int32, primary_key: true
      field :job_id, Int32
      field :job, String
      field :description, String
      field :status, String
      field :response, String
    end
  end
end