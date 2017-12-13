/*
 * call-session.h
 * Copyright (C) 2010-2017 Belledonne Communications SARL
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.
 */

#ifndef _CALL_SESSION_H_
#define _CALL_SESSION_H_

#include "object/object.h"
#include "address/address.h"
#include "conference/conference.h"
#include "conference/params/call-session-params.h"
#include "conference/session/call-session-listener.h"
#include "core/core-listener.h"
#include "sal/call-op.h"

// =============================================================================

LINPHONE_BEGIN_NAMESPACE

class CallPrivate;
class CallSessionPrivate;
class Content;
class Core;

class LINPHONE_PUBLIC CallSession : public Object, public CoreAccessor {
	friend class Call;
	friend class CallPrivate;
	friend class ClientGroupChatRoom;
	friend class ClientGroupChatRoomPrivate;
	friend class Conference;
	friend class CorePrivate;
	friend class ServerGroupChatRoom;
	friend class ServerGroupChatRoomPrivate;

public:
	L_OVERRIDE_SHARED_FROM_THIS(CallSession);

	CallSession (const std::shared_ptr<Core> &core, const CallSessionParams *params, CallSessionListener *listener);
	virtual ~CallSession ();

	LinphoneStatus accept (const CallSessionParams *csp = nullptr);
	LinphoneStatus acceptUpdate (const CallSessionParams *csp);
	virtual void configure (LinphoneCallDir direction, LinphoneProxyConfig *cfg, SalCallOp *op, const Address &from, const Address &to);
	LinphoneStatus decline (LinphoneReason reason);
	LinphoneStatus decline (const LinphoneErrorInfo *ei);
	LinphoneStatus declineNotAnswered (LinphoneReason reason);
	virtual LinphoneStatus deferUpdate ();
	bool hasTransferPending ();
	virtual void initiateIncoming ();
	virtual bool initiateOutgoing ();
	virtual void iterate (time_t currentRealTime, bool oneSecondElapsed);
	LinphoneStatus redirect (const std::string &redirectUri);
	LinphoneStatus redirect (const Address &redirectAddr);
	virtual void startIncomingNotification ();
	virtual int startInvite (const Address *destination, const std::string &subject = "", const Content *content = nullptr);
	LinphoneStatus terminate (const LinphoneErrorInfo *ei = nullptr);
	LinphoneStatus transfer (const std::shared_ptr<CallSession> &dest);
	LinphoneStatus transfer (const std::string &dest);
	LinphoneStatus update (const CallSessionParams *csp, const std::string &subject = "", const Content *content = nullptr);

	CallSessionParams *getCurrentParams () const;
	LinphoneCallDir getDirection () const;
	const Address& getDiversionAddress () const;
	int getDuration () const;
	const LinphoneErrorInfo * getErrorInfo () const;
	LinphoneCallLog * getLog () const;
	virtual const CallSessionParams *getParams () const;
	LinphoneReason getReason () const;
	std::shared_ptr<CallSession> getReferer () const;
	std::string getReferTo () const;
	const Address& getRemoteAddress () const;
	std::string getRemoteAddressAsString () const;
	std::string getRemoteContact () const;
	const Address *getRemoteContactAddress () const;
	const CallSessionParams *getRemoteParams ();
	std::string getRemoteUserAgent () const;
	std::shared_ptr<CallSession> getReplacedCallSession () const;
	LinphoneCallState getState () const;
	const Address& getToAddress () const;
	LinphoneCallState getTransferState () const;
	std::shared_ptr<CallSession> getTransferTarget () const;
	std::string getToHeader (const std::string &name) const;

protected:
	explicit CallSession (CallSessionPrivate &p, const std::shared_ptr<Core> &core);

private:
	L_DECLARE_PRIVATE(CallSession);
	L_DISABLE_COPY(CallSession);
};

LINPHONE_END_NAMESPACE

#endif // ifndef _CALL_SESSION_H_
