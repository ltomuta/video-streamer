/**
 * Copyright (c) 2012 Nokia Corporation.
 * All rights reserved.
 *
 * Part of the QMLVideoStreamer.
 * Based on volumekeys.h from Qt GameEnabler.
 *
 * For the applicable distribution terms see the license text file included in
 * the distribution.
 */

#include <QDebug>
#include "volumekeys.h"

/*!
  \class VolumeKeys
  \brief Symbian specific utility for reacting to hardware volume buttons.
*/
VolumeKeys::VolumeKeys(QObject *parent)
    : QObject(parent),
      m_interfaceSelector(0),
      m_coreTarget(0)
{
    QT_TRAP_THROWING(
        m_interfaceSelector = CRemConInterfaceSelector::NewL();
    m_coreTarget = CRemConCoreApiTarget::NewL(*m_interfaceSelector, *this);
    m_interfaceSelector->OpenTargetL();
    );
}

VolumeKeys::~VolumeKeys()
{
    delete m_interfaceSelector;
    m_interfaceSelector = 0;
    m_coreTarget = 0; // owned by interfaceselector
}

void VolumeKeys::MrccatoCommand(TRemConCoreApiOperationId operationId,
                                TRemConCoreApiButtonAction buttonAct)
{
    if (buttonAct == ERemConCoreApiButtonClick) {
        if (operationId == ERemConCoreApiVolumeUp) {
            emit volumeKeyUp();
        }
        else if (operationId == ERemConCoreApiVolumeDown) {
            emit volumeKeyDown();
        }
    }
}
