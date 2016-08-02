This is the outcome of a survey of used codecs on our customers equipments, based on a few hours of captured SDP trafic.

Further References:
  https://tools.ietf.org/html/rfc3551#section-4.5
  → https://tools.ietf.org/html/rfc3555
  → https://www.iana.org/assignments/rtp-parameters/rtp-parameters.xhtml#rtp-parameters-1 -- standard names, closed

SDP = https://tools.ietf.org/html/rfc4566

Observed rtpmap strings:

a=rtpmap:0 PCMU/8000                  Invalid in Europe
a=rtpmap:0 PCMU/8000/1                Invalid in Europe
a=rtpmap:100 NSE/8000                 Cisco NSE (only offered by SPA-112)
a=rtpmap:101 telephone-event/8000     RFC4733
a=rtpmap:103 telephone-event/8000
a=rtpmap:103 telephone-event/8000
a=rtpmap:111 iLBC/8000/1              low bandwidth, not interesting [RFC3952](https://tools.ietf.org/html/rfc3952)
a=rtpmap:125 CLEARMODE/8000/1         Offered by carrier
a=rtpmap:13 CN/8000                   Comfort Noise
a=rtpmap:18 G729/8000                 low bandwitdh, not interesting
a=rtpmap:18 G729/8000/1
a=rtpmap:18 G729a/8000                (invalid codec name)
a=rtpmap:2 G726-32/8000
a=rtpmap:4 G723/8000
a=rtpmap:4 G723/8000/1
a=rtpmap:8 PCMA/8000
a=rtpmap:8 PCMA/8000/1
a=rtpmap:8 pcma/8000                  SnomPBX, dude
a=rtpmap:9 G722/8000                  Actually 16kHz, aka HD
a=rtpmap:96 G726-32/8000
a=rtpmap:96 G726-40/8000
a=rtpmap:97 AAL2-G726-32/8000
a=rtpmap:97 G726-24/8000
a=rtpmap:98 G726-16/8000
a=rtpmap:99 SILK/24000                Skype's codec, supported by codec/mod_silk


Speex is obsolete, use Opus instead. https://en.wikipedia.org/wiki/Speex
SILK is embedded in Opus.

others...
a=rtpmap:98 L16/8000/1
a=rtpmap:98 L16/16000/2
a=rtpmap:98 OPUS/

Codecs DE410IP:
- G.722
- G.711 (A/µ)
- G.726
- iLbc
- G.729A

Codec choices:

(dans src/switch_core_media.c :: switch_core_media_get_codec_string ):

  no media: preferred = fallback = PCMU
  otherwise (normal):
  preferred = channel's `absolute_codec_string` | channel's `codec_string`
  if preferred not set from channel's:
    use profile's *bound_codec_string (inbound if call direction is inbound, outbound if calls direction is outbound; if one of them is empty, use the other one)

Note that `switch_core_media_prepare_codecs` (the only user of the function above)
- will use `absolute_codec_string` if it is present
- will use `originator_codec` if `media_mix_inbound_outbound_codecs` is false/absent
- will use `codec_string` if is present
and will default to `PCMU@20i,PCMA@20i,speex@20i`.
The resulting choices are stored in channel's `rtp_use_codec_string`.
