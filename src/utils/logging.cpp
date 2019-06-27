/*
 * TessuMod: Mod for integrating TeamSpeak into World of Tanks
 * Copyright (C) 2015  Janne Hakonen
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301
 * USA
 */

#include "logging.h"
#include "../entities/vector.h"

#include <QTextStream>
#include <QFile>

namespace {

Log::Sink *gLogSink = NULL;

}

namespace Log
{

std::shared_ptr<Stream> debug( const char *channel )
{
	std::shared_ptr<Stream> stream = std::make_shared<Stream>();
	stream->channel = channel;
	stream->severity = Debug;
	return stream;
}

std::shared_ptr<Stream> info( const char *channel )
{
	std::shared_ptr<Stream> stream = std::make_shared<Stream>();
	stream->channel = channel;
	stream->severity = Info;
	return stream;
}

std::shared_ptr<Stream> warning( const char *channel )
{
	std::shared_ptr<Stream> stream = std::make_shared<Stream>();
	stream->channel = channel;
	stream->severity = Warning;
	return stream;
}

std::shared_ptr<Stream> error( const char *channel )
{
	std::shared_ptr<Stream> stream = std::make_shared<Stream>();
	stream->channel = channel;
	stream->severity = Error;
	return stream;
}

void setSink( Sink *sink )
{
	gLogSink = sink;
}

Stream::~Stream()
{
	if( gLogSink )
	{
		gLogSink->logMessage( message, channel, severity );
	}
}

std::shared_ptr<Stream> operator<<( std::shared_ptr<Stream> stream, const QString &value )
{
	QTextStream textStream( &stream->message );
	textStream << value;
	return stream;
}

std::shared_ptr<Stream> operator<<( std::shared_ptr<Stream> stream, quint16 value )
{
	QTextStream textStream( &stream->message );
	textStream << value;
	return stream;
}

std::shared_ptr<Stream> operator<<( std::shared_ptr<Stream> stream, const Entity::Vector &value )
{
	QTextStream textStream( &stream->message );
	textStream << "(" << value.x << ", " << value.y << ", " << value.z << ")";
	return stream;
}

void qtMessageHandler( QtMsgType type, const QMessageLogContext &context, const QString &message )
{
	QString formattedMessage = QString( "%1 (%2:%3, %4)" )
			.arg( message )
			.arg( context.file )
			.arg( context.line )
			.arg( context.function );
	switch( type )
	{
	case QtDebugMsg:
	case QtInfoMsg:
		debug() << formattedMessage;
		break;
	case QtWarningMsg:
		warning() << formattedMessage;
		break;
	case QtCriticalMsg:
		error() << formattedMessage;
		break;
	case QtFatalMsg:
		error() << formattedMessage;
		abort();
	}
}

void logQtMessages()
{
	qInstallMessageHandler( qtMessageHandler );
}

FileLogger::FileLogger( const QString &filepath )
{
	logFile = new QFile( filepath );
	logFile->open( QFile::WriteOnly | QFile::Truncate );
}

FileLogger::~FileLogger()
{
	delete logFile;
}

void FileLogger::logMessage(const QString &message, const char *channel, Severity severity )
{
	Q_UNUSED( severity );
	Q_UNUSED( channel );
	logFile->write( message.toUtf8() );
	logFile->write( "\n" );
	logFile->flush();
}

}
