module Model
  class JobStatus < Crecto::Model

      schema "job_status" do # table name
          field :id, Int32, primary_key: true
          field :job_id, Int32
          field :status, String
          field :response, String
      end

      validate_required [:job_id]
  end
end