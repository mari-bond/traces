require 'rails_helper'

describe TracesController do
  let(:trace) { create(:trace) }
  let(:poin1_data) {{ "latitude" => '32.9377784729004', "longitude" => '-117.230392456055' }}
  let(:poin2_data) {{ "latitude" => '32.937801361084', "longitude" => '-117.230323791504' }}
  let(:data) { [poin1_data, poin2_data] }

  it {expect(subject).to be_a_kind_of ApplicationController}

  it 'index' do
    traces = [trace]
    Trace.stub(:includes).with(:points).and_return(traces)
    get(:index, { format: :json })

    json = JSON.parse(response.body)
    expect(json['traces']).to serialize_objects(traces).with(TraceSerializer)
    expect(response.status).to eq(200)
  end

  it 'show' do
    get(:show, { id: trace.id, format: :json })

    expect(assigns(:trace)).to eq trace
    json = JSON.parse(response.body)
    expect(json['trace']).to serialize_object(trace).with(TraceSerializer)
    expect(response.status).to eq(200)
  end

  describe 'create' do
    before do
      trace.stub(:import_points)
      Trace.stub(:new).and_return(trace)
    end

    def request
      post(:create, { _json: data, format: :json })
    end

    it 'success creation' do
      trace.stub(:save).and_return(true)
      request

      expect(trace).to have_received(:import_points).with(data)
      json = JSON.parse(response.body)
      expect(json['trace']).to serialize_object(trace).with(TraceSerializer)
      expect(response.status).to eq(201)
    end

    it 'fail creation' do
      trace.stub(:save).and_return(false)
      request

      expect(trace).not_to have_received(:import_points).with(data)
      json = JSON.parse(response.body)
      expect(json['trace']).to serialize_object(trace).with(TraceSerializer)
      expect(response.status).to eq(400)
    end
  end

  it 'update' do
    Trace.any_instance.stub(:import_points)
    put(:update, { id: trace.id, _json: data, format: :json })

    expect(assigns(:trace)).to eq trace
    target_trace = subject.instance_variable_get("@trace")
    expect(target_trace).to have_received(:import_points).with(data)
    json = JSON.parse(response.body)
    expect(json['trace']).to serialize_object(trace).with(TraceSerializer)
    expect(response.status).to eq(200)
  end

  describe 'destroy' do
    def request
      delete(:destroy, { id: trace.id, format: :json })
    end

    it 'success' do
      Trace.any_instance.stub(:destroy).and_return(true)
      request

      expect(assigns(:trace)).to eq trace
      target_trace = subject.instance_variable_get("@trace")
      expect(target_trace).to have_received(:destroy)
      json = JSON.parse(response.body)
      expect(json['trace']).to serialize_object(trace).with(TraceSerializer)
      expect(response.status).to eq(200)
    end

    it 'fail' do
      Trace.any_instance.stub(:destroy).and_return(false)
      request

      expect(assigns(:trace)).to eq trace
      target_trace = subject.instance_variable_get("@trace")
      expect(target_trace).to have_received(:destroy)
      json = JSON.parse(response.body)
      expect(json['trace']).to serialize_object(trace).with(TraceSerializer)
      expect(response.status).to eq(400)
    end
  end
end