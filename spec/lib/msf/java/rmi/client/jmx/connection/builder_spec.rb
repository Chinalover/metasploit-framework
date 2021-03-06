# -*- coding:binary -*-
require 'spec_helper'

require 'stringio'
require 'rex/java/serialization'
require 'rex/proto/rmi'
require 'msf/java/rmi/client'

describe Msf::Java::Rmi::Client::Jmx::Connection::Builder do
  subject(:mod) do
    mod = ::Msf::Exploit.new
    mod.extend ::Msf::Java::Rmi::Client
    mod.send(:initialize)
    mod
  end

  let(:mlet_name) do
    'DefaultDomain:type=MLet'
  end

  let(:default_get_object_instance) do
    "\x50\xac\xed\x00\x05\x77\x22\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff" +
    "\xff\xf0\xe0\x74\xea\xad\x0c\xae\xa8\x70"
  end

  let(:mlet_get_object_instance) do
    "\x50\xac\xed\x00\x05\x77\x22\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff" +
    "\xff\xf0\xe0\x74\xea\xad\x0c\xae\xa8\x70"
  end

  let(:mbean_name) do
    'javax.management.loading.MLet'
  end

  let(:default_create_mbean) do
    "\x50\xac\xed\x00\x05\x77\x22\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff" +
    "\xff\x22\xd7\xfd\x4a\x90\x6a\xc8\xe6\x74\x00\x00\x70\x70"
  end

  let(:mlet_create_mbean) do
    "\x50\xac\xed\x00\x05\x77\x22\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff" +
    "\xff\x22\xd7\xfd\x4a\x90\x6a\xc8\xe6\x74\x00\x1d\x6a\x61\x76\x61" +
    "\x78\x2e\x6d\x61\x6e\x61\x67\x65\x6d\x65\x6e\x74\x2e\x6c\x6f\x61" +
    "\x64\x69\x6e\x67\x2e\x4d\x4c\x65\x74\x70\x70"
  end

  let(:invoke_opts) do
    {
      object: 'DefaultDomain:type=MLet',
      method: 'getMBeansFromURL',
      args: { 'java.lang.String' => "http://127.0.0.1/mlet" }
    }
  end

  let(:default_invoke) do
    "\x50\xac\xed\x00\x05\x77\x22\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff" +
    "\xff\x13\xe7\xd6\x94\x17\xe5\xda\x20\x73\x72\x00\x1b\x6a\x61\x76" +
    "\x61\x78\x2e\x6d\x61\x6e\x61\x67\x65\x6d\x65\x6e\x74\x2e\x4f\x62" +
    "\x6a\x65\x63\x74\x4e\x61\x6d\x65\x0f\x03\xa7\x1b\xeb\x6d\x15\xcf" +
    "\x03\x00\x00\x70\x78\x70\x74\x00\x00\x78\x74\x00\x00\x73\x72\x00" +
    "\x19\x6a\x61\x76\x61\x2e\x72\x6d\x69\x2e\x4d\x61\x72\x73\x68\x61" +
    "\x6c\x6c\x65\x64\x4f\x62\x6a\x65\x63\x74\x7c\xbd\x1e\x97\xed\x63" +
    "\xfc\x3e\x02\x00\x03\x49\x00\x04\x68\x61\x73\x68\x5b\x00\x08\x6c" +
    "\x6f\x63\x42\x79\x74\x65\x73\x74\x00\x02\x5b\x42\x5b\x00\x08\x6f" +
    "\x62\x6a\x42\x79\x74\x65\x73\x74\x00\x02\x5b\x42\x70\x78\x70\x72" +
    "\x69\x21\xc6\x70\x75\x72\x00\x02\x5b\x42\xac\xf3\x17\xf8\x06\x08" +
    "\x54\xe0\x02\x00\x00\x70\x78\x70\x00\x00\x00\x2c\xac\xed\x00\x05" +
    "\x75\x72\x00\x13\x5b\x4c\x6a\x61\x76\x61\x2e\x6c\x61\x6e\x67\x2e" +
    "\x4f\x62\x6a\x65\x63\x74\x3b\x90\xce\x58\x9f\x10\x73\x29\x6c\x02" +
    "\x00\x00\x78\x70\x00\x00\x00\x00\x75\x72\x00\x13\x5b\x4c\x6a\x61" +
    "\x76\x61\x2e\x6c\x61\x6e\x67\x2e\x53\x74\x72\x69\x6e\x67\x3b\xad" +
    "\xd2\x56\xe7\xe9\x1d\x7b\x47\x02\x00\x00\x70\x78\x70\x00\x00\x00" +
    "\x00\x70"
  end

  let(:invoke_with_data) do
    "\x50\xac\xed\x00\x05\x77\x22\x00\x00\x00\x00\x00\x00\x00\x00\x00" +
    "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xff\xff\xff" +
    "\xff\x22\xd7\xfd\x4a\x90\x6a\xc8\xe6\x74\x00\x00\x70\x70"
  end

  describe "#build_jmx_get_object_instance" do
    context "when no opts" do
      it "creates a Rex::Proto::Rmi::Model::Call" do
        expect(mod.build_jmx_new_client).to be_a(Rex::Proto::Rmi::Model::Call)
      end

      it "creates a getObjectInstance call for an empty object name" do
        expect(mod.build_jmx_new_client.encode).to eq(default_get_object_instance)
      end
    end

    context "when opts with class name" do
      it "creates a Rex::Proto::Rmi::Model::Call" do
        expect(mod.build_jmx_new_client(name: mlet_name)).to be_a(Rex::Proto::Rmi::Model::Call)
      end

      it "creates a getObjectInstance Call with credentials" do
        expect(mod.build_jmx_new_client(name: mlet_name).encode).to eq(mlet_get_object_instance)
      end
    end
  end

  describe "#build_jmx_new_client_args" do
    it "return an Array" do
      expect(mod.build_jmx_get_object_instance_args(mlet_name)).to be_an(Array)
    end

    it "returns an Array with 4 elements" do
      expect(mod.build_jmx_get_object_instance_args(mlet_name).length).to eq(4)
    end

    it "returns an Array whose second element is an utf string with the object name" do
      expect(mod.build_jmx_get_object_instance_args(mlet_name)[1].contents).to eq(mlet_name)
    end
  end

  describe "#build_jmx_create_mbean" do
    context "when no opts" do
      it "creates a Rex::Proto::Rmi::Model::Call" do
        expect(mod.build_jmx_create_mbean).to be_a(Rex::Proto::Rmi::Model::Call)
      end

      it "creates a createMBean call for an empty object name" do
        expect(mod.build_jmx_create_mbean.encode).to eq(default_create_mbean)
      end
    end

    context "when opts with class name" do
      it "creates a Rex::Proto::Rmi::Model::Call" do
        expect(mod.build_jmx_create_mbean(name: mbean_name)).to be_a(Rex::Proto::Rmi::Model::Call)
      end

      it "creates a createMBean Call with credentials" do
        expect(mod.build_jmx_create_mbean(name: mbean_name).encode).to eq(mlet_create_mbean)
      end
    end
  end

  describe "#build_jmx_create_mbean_args" do
    it "return an Array" do
      expect(mod.build_jmx_create_mbean_args(mbean_name)).to be_an(Array)
    end

    it "returns an Array with 3 elements" do
      expect(mod.build_jmx_create_mbean_args(mbean_name).length).to eq(3)
    end

    it "returns an Array whose first element is an utf string with the object name" do
      expect(mod.build_jmx_create_mbean_args(mbean_name)[0].contents).to eq(mbean_name)
    end
  end


  describe "#build_jmx_invoke" do
    context "when no opts" do
      it "creates a Rex::Proto::Rmi::Model::Call" do
        expect(mod.build_jmx_invoke).to be_a(Rex::Proto::Rmi::Model::Call)
      end

      it "creates a default invoke" do
        expect(mod.build_jmx_invoke.encode).to eq(default_invoke)
      end
    end

    context "when opts with class name" do
      it "creates a Rex::Proto::Rmi::Model::Call" do
        expect(mod.build_jmx_create_mbean(invoke_opts)).to be_a(Rex::Proto::Rmi::Model::Call)
      end

      it "creates a invoke call with the opts data" do
        expect(mod.build_jmx_create_mbean(invoke_opts).encode).to eq(invoke_with_data)
      end
    end
  end

  describe "#build_jmx_invoke_args" do
    it "return an Array" do
      expect(mod.build_jmx_invoke_args(invoke_opts)).to be_an(Array)
    end

    it "returns an Array with 7 elements" do
      expect(mod.build_jmx_invoke_args(invoke_opts).length).to eq(7)
    end

    it "returns an Array whose second element is an utf string with the object name" do
      expect(mod.build_jmx_invoke_args(invoke_opts)[1].contents).to eq(mlet_name)
    end

    it "returns an Array whose third element is an utf string with the method name" do
      expect(mod.build_jmx_invoke_args(invoke_opts)[3].contents).to eq('getMBeansFromURL')
    end
  end

  describe "#build_invoke_arguments_obj_bytes" do
    it "return an Rex::Java::Serialization::Model::Stream" do
      expect(mod.build_invoke_arguments_obj_bytes(invoke_opts[:args])).to be_a(Rex::Java::Serialization::Model::Stream)
    end

    it "returns an stream with one content" do
      expect(mod.build_invoke_arguments_obj_bytes(invoke_opts[:args]).contents.length).to eq(1)
    end

    it "returns an stream with NewArray" do
      expect(mod.build_invoke_arguments_obj_bytes(invoke_opts[:args]).contents[0]).to be_a(Rex::Java::Serialization::Model::NewArray)
    end
  end


end

