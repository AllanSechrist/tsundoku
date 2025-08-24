# README

📚 Tsundoku API

This is a Ruby on Rails API that powers a Bookclub application. The API manages bookclubs, users, and invites, and is designed to be consumed by a React frontend (currently under development).

🚀 Features

Users & Bookclubs:
Users can join or create bookclubs.

Invites:

Send invites by user ID or email

Track invite status (pending, accepted, declined, revoked)

Expiration & response timestamps

Secure invite tokens

Serialization:
API responses are structured using jsonapi-serializer to keep data consistent and frontend-friendly.

🛠️ Tech Stack

Backend: Ruby on Rails (API mode)

Database: PostgreSQL (with schema-managed associations & indexes)

Auth: Devise JWT (planned)

Serialization: jsonapi-serializer

Frontend: React (separate project, not yet integrated)

🔗 Example API Endpoints

Method	Endpoint	Description

GET	/bookclubs	List all bookclubs

POST	/bookclubs	Create a new bookclub

POST	/invites	Create a new invite

PATCH	/invites/:id/accept	Accept an invite

PATCH	/invites/:id/decline	Decline an invite

📌 Roadmap

 Basic models & serializers

 Invite system with tokens

 Authentication with Devise JWT

 Connect React frontend (mobile-first)

 Deploy to Heroku
