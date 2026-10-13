CREATE TABLE public.notifications (
                                      id uuid DEFAULT gen_random_uuid() NOT NULL,
                                      recipient_id uuid NOT NULL,
                                      actor_id uuid NULL,
                                      title varchar(255) NOT NULL,
                                      message text NOT NULL,
                                      "type" varchar(64) NOT NULL,
                                      priority varchar(32) DEFAULT 'MEDIUM'::character varying NOT NULL,
                                      target_type varchar(64) NULL,
                                      target_id varchar(128) NULL,
                                      is_read bool DEFAULT false NOT NULL,
                                      read_at timestamp NULL,
                                      created_at timestamp DEFAULT CURRENT_TIMESTAMP NOT NULL,
                                      CONSTRAINT notifications_pkey PRIMARY KEY (id)
);
CREATE INDEX idx_notifications_recipient_created_at ON public.notifications USING btree (recipient_id, created_at DESC);
CREATE INDEX idx_notifications_recipient_is_read ON public.notifications USING btree (recipient_id, is_read);