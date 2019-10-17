require 'ffi'

module Apple
  module System
    module LoggerFunctions
      extend FFI::Library
      ffi_lib FFI::Library::LIBC

      attach_function(:asl_add_log_file, [:pointer, :int], :int)
      attach_function(:asl_close, [:pointer], :void)
      attach_function(:asl_free, [:pointer], :void)
      attach_function(:asl_get, [:pointer, :string], :string)
      attach_function(:asl_key, [:pointer, :uint32], :string)
      attach_function(:asl_log, [:pointer, :pointer, :int, :string], :int)
      attach_function(:asl_new, [:uint32], :pointer)
      attach_function(:asl_open, [:string, :string, :uint32], :pointer)
      attach_function(:asl_remove_log_file, [:pointer, :int], :int)
      attach_function(:asl_search, [:pointer, :pointer], :pointer)
      attach_function(:asl_send, [:pointer, :pointer], :int)
      attach_function(:asl_set, [:pointer, :string, :string], :int)
      attach_function(:asl_set_filter, [:pointer, :int], :int)
      attach_function(:asl_set_query, [:pointer, :string, :string, :uint32], :int)
      attach_function(:asl_unset, [:pointer, :string], :int)
      attach_function(:asl_vlog, [:pointer, :pointer, :int, :string, :pointer], :int)
      attach_function(:aslresponse_free, [:pointer], :void)
      attach_function(:aslresponse_next, [:pointer], :pointer)
    end
  end
end
