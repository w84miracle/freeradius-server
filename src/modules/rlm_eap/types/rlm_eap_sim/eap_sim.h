/*
 *   This program is is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or (at
 *   your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program; if not, write to the Free Software
 *   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA
 */

/**
 * $Id$
 *
 * @file rlm_eap_sim/eap_sim.h
 * @brief Declarations for EAP-SIM
 *
 * @author Arran Cudbard-Bell
 *
 * @copyright 2016 The FreeRADIUS server project
 * @copyright 2016 Arran Cudbard-Bell
 */
RCSIDH(rlm_eap_sim_eap_sim_h, "$Id$")

extern fr_dict_t *dict_sim;
extern fr_dict_t *dict_aka;

#include "sim_proto.h"

/** Server states
 *
 * In server_start, we send a EAP-SIM Start message.
 */
typedef enum {
	EAP_SIM_SERVER_START		= 0,
	EAP_SIM_SERVER_CHALLENGE	= 1,
	EAP_SIM_SERVER_SUCCESS		= 10,
	EAP_SIM_SERVER_MAX_STATES
} eap_sim_server_state_t;

typedef struct eap_aka_session {
	eap_sim_server_state_t	state;		//!< Current session state.
	fr_sim_keys_t		keys;		//!< Various EAP-AKA keys.
	int  			sim_id;		//!< Packet ID. (replay protection)
} eap_sim_session_t;
