indexing

	description:

		"Access to <sys/soundcard.h>"

	author: "Berend de Boer <berend@pobox.com>"
	copyright: "Copyright (c) 2004, Berend de Boer and others"
	license: "MIT License"
	date: "$Date: 2007/11/22 $"
	revision: "$Revision: #3 $"


class

	LAPI_SOUNDCARD


feature -- ioctl status retrieval constants

	SNDCTL_DSP_GETBLKSIZE: INTEGER is
			-- Get current block size.
		external "C"
		alias "const_sndctl_dsp_getblksize"
		end

	SNDCTL_DSP_GETCAPS: INTEGER is
			-- Get capabilities into 32-bit integer. Bits indicate what
			-- is supported.
		external "C"
		alias "const_sndctl_dsp_getcaps"
		end

	SNDCTL_DSP_GETFMTS: INTEGER is
			-- Get supported formats into 32-bit integer. Bits indicate
			-- what is supported.
		external "C"
		alias "const_sndctl_dsp_getfmts"
		end


feature -- ioctl change constants

-- 	SNDCTL_DSP_RESET: INTEGER is
-- 			-- Stops the device immediately and returns it to a state
-- 			-- where it can accept new parameters. It should not be
-- 			-- called after opening the device as it may cause unwanted
-- 			-- side effects in this situation. The call is only required
-- 			-- when recording or playback needs to be aborted. In
-- 			-- general, opening and closing the device is recommended
-- 			-- after using SNDCTL_DSP_RESET.
-- 		external "C"
-- 		alias "const_sndctl_dsp_channels"
-- 		end

	SNDCTL_DSP_CHANNELS: INTEGER is
			-- Set number of output channels.
		external "C"
		alias "const_sndctl_dsp_channels"
		end

	SNDCTL_DSP_SETFMT: INTEGER is
			-- Set number of bits per sample.
		external "C"
		alias "const_sndctl_dsp_setfmt"
		end

	SNDCTL_DSP_SETFRAGMENT: INTEGER is
			-- Set number of fragments and fragment size.
		external "C"
		alias "const_sndctl_dsp_setfragment"
		end

	SNDCTL_DSP_SPEED: INTEGER is
			-- Set sampling rate.
		external "C"
		alias "const_sndctl_dsp_speed"
		end


feature -- Audio device capabilities

	DSP_CAP_DUPLEX: INTEGER is 256
			-- Full duplex record/playback

	DSP_CAP_REALTIME: INTEGER is 512
			-- Real time capability

	DSP_CAP_BATCH: INTEGER is 1024
			-- Device has some kind of internal buffers which may cause
			-- some delays and decrease precision of timing

	DSP_CAP_COPROC: INTEGER is 2048
			-- Has a coprocessor
			-- Sometimes it's a DSP, but usually not.


feature -- Audio data formats

	AFMT_QUERY: INTEGER is 0
			-- Return currently used format

	AFMT_MU_LAW: INTEGER is 1

	AFMT_A_LAW: INTEGER is 2

	AFMT_IMA_ADPCM: INTEGER is 4

	AFMT_U8: INTEGER is 8
			-- Unsigned 8 bits

	AFMT_S16_LE: INTEGER is 16
			-- Signed 16 bits, little endian

	AFMT_S16_BE: INTEGER is 32
			-- Signed 16 bits, big endian

	AFMT_S8: INTEGER is 64
			-- Signed 8 bits

	AFMT_U16_LE: INTEGER is 128
			-- Unsigned 16 bits, little endian

	AFMT_U16_BE: INTEGER is 256
			-- Unsigned 16 bits, big endian

	AFMT_MPEG: INTEGER is 512
			-- MPEG (2) audio

	AFMT_AC3: INTEGER is 1024
			-- Dolby Digital AC3

end
