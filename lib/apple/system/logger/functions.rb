# frozen_string_literal: true

require 'ffi'

module Apple
  module System
    module LoggerFunctions
      extend FFI::Library
      ffi_lib FFI::Library::LIBC

      attach_function(:asl_add_log_file, %i[pointer int], :int)
      attach_function(:asl_close, [:pointer], :void)
      attach_function(:asl_free, [:pointer], :void)
      attach_function(:asl_get, %i[pointer string], :string)
      attach_function(:asl_key, %i[pointer uint32], :string)
      attach_function(:asl_log, %i[pointer pointer int string varargs], :int)
      attach_function(:asl_new, [:uint32], :pointer)
      attach_function(:asl_open, %i[string string uint32], :pointer)
      attach_function(:asl_remove_log_file, %i[pointer int], :int)
      attach_function(:asl_search, %i[pointer pointer], :pointer)
      attach_function(:asl_send, %i[pointer pointer], :int)
      attach_function(:asl_set, %i[pointer string string], :int)
      attach_function(:asl_set_filter, %i[pointer int], :int)
      attach_function(:asl_set_query, %i[pointer string string uint32], :int)
      attach_function(:asl_unset, %i[pointer string], :int)
      attach_function(:asl_vlog, %i[pointer pointer int string pointer], :int)
      attach_function(:aslresponse_free, [:pointer], :void)
      attach_function(:aslresponse_next, [:pointer], :pointer)
    end
  end
end
