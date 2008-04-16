indexing

	description: "Class that covers Posix aio.h."

	author: "Berend de Boer"
	date: "$Date: 2007/05/18 $"
	revision: "$Revision: #1 $"

class

	PAPI_AIO


feature -- functions

	posix_aio_cancel(a_fildes: INTEGER; a_aiocbp: POINTER): INTEGER is
			-- Cancel asynchronous i/o operation.
		require
			valid_fildes: a_fildes >= 0
		external "C"
		end

	posix_aio_error(a_aiocbp: POINTER): INTEGER is
			-- Retrieve error status of asynchronous i/o operation.
		external "C"
		end

	posix_aio_fsync(op: INTEGER a_aiocbp: POINTER): INTEGER is
			-- Asynchronous file synchronization.

		external "C blocking"



		end

	posix_aio_read(a_aiocbp: POINTER): INTEGER is
			-- Asynchronous read.
		external "C"
		end

	posix_aio_return(a_aiocbp: POINTER): INTEGER is
			-- Retrieve return status of asynchronous i/o operation.
		external "C"
		end

	posix_aio_suspend(a_list: POINTER; nent: INTEGER; timespec: POINTER): INTEGER is
			-- Wait for one or more asynchronous i/o request.

		external "C blocking"



		end

	posix_aio_write(a_aiocbp: POINTER): INTEGER is
			-- Asynchronous write.
		external "C"
		end


feature -- C binding for members of aiocb

	posix_aiocb_size: INTEGER is
		external "C"
		end

	posix_aiocb_aio_fildes (a_aiocb: POINTER): INTEGER is
			-- file descriptor
		external "C"
		end

	posix_aiocb_aio_lio_opcode (a_aiocb: POINTER): INTEGER is
			-- operation to be performaed
		external "C"
		end

	posix_aiocb_aio_reqprio (a_aiocb: POINTER): INTEGER is
			-- request priority offset
		external "C"
		end

	posix_aiocb_aio_buf (a_aiocb: POINTER): POINTER is
			-- location of buffer
		external "C"
		end

	posix_aiocb_aio_nbytes (a_aiocb: POINTER): INTEGER is
			-- length of transfer
		external "C"
		end

	posix_aiocb_aio_sigevent (a_aiocb: POINTER): POINTER is
			-- signal number and value
		external "C"
		end

	posix_aiocb_aio_offset (a_aiocb: POINTER): INTEGER is
			-- file offset
		external "C"
		end


	posix_set_aiocb_aio_fildes (a_aiocb: POINTER; aio_fildes: INTEGER) is
		require
			valid_fildes: aio_fildes >= 0
		external "C"
		end

	posix_set_aiocb_aio_lio_opcode (a_aiocb: POINTER; aio_lio_opcode: INTEGER) is
		external "C"
		end

	posix_set_aiocb_aio_reqprio (a_aiocb: POINTER; aio_reqprio: INTEGER) is
		external "C"
		end

	posix_set_aiocb_aio_buf (a_aiocb: POINTER; aio_buf: POINTER) is
		external "C"
		end

	posix_set_aiocb_aio_nbytes (a_aiocb: POINTER; aio_nbytes: INTEGER) is
		external "C"
		end

	posix_set_aiocb_aio_offset (a_aiocb: POINTER; aio_offset: INTEGER) is
		external "C"
		end


feature -- return values of aio_cancel

	AIO_CANCELED: INTEGER is
		external "C"
		alias "const_aio_canceled"
		end

	AIO_NOTCANCELED: INTEGER is
		external "C"
		alias "const_aio_notcanceled"
		end

	AIO_ALLDONE: INTEGER is
		external "C"
		alias "const_aio_alldone"
		end

feature {NONE} -- lio_listio options

	LIO_READ: INTEGER is
		external "C"
		alias "const_lio_read"
		end

	LIO_WRITE: INTEGER is
		external "C"
		alias "const_lio_write"
		end

	LIO_NOP: INTEGER is
		external "C"
		alias "const_lio_nop"
		end

	LIO_WAIT: INTEGER is
			-- a lio_listio synchronization option indicating that the
			-- calling thread is to suspend until the lio_listio operation
			-- is complete
		external "C"
		alias "const_lio_wait"
		end

	LIO_NOWAIT: INTEGER is
			-- a lio_listio synchronization option indicating that the
			-- calling thread is to continue, no notification is given
			-- when the operation is complete
		external "C"
		alias "const_lio_nowait"
		end

end -- class PAPI_AIO
