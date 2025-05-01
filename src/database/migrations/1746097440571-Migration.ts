import { MigrationInterface, QueryRunner } from "typeorm";

export class Migration1746097440571 implements MigrationInterface {
    name = 'Migration1746097440571'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TYPE "public"."availability_schedules_dayofweek_enum" AS ENUM('monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday')`);
        await queryRunner.query(`CREATE TABLE "availability_schedules" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "dayOfWeek" "public"."availability_schedules_dayofweek_enum" NOT NULL, "parkingId" uuid NOT NULL, CONSTRAINT "PK_cfb5fcd683ea4ea6bec3183a216" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "availability_time_slots" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "startTime" character varying NOT NULL, "endTime" character varying NOT NULL, "scheduleId" uuid, "exceptionId" uuid, CONSTRAINT "PK_054bcc5544631a8dc3641f31658" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "availability_exceptions" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "date" character varying NOT NULL, "available" boolean NOT NULL, "parkingId" uuid NOT NULL, CONSTRAINT "PK_f5a89a7a6221bc93b517a13351f" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "parking_features" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "name" character varying NOT NULL, "parkingId" uuid NOT NULL, CONSTRAINT "PK_0ca5cb7859308bbe03321235d40" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "parking_photos" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "url" character varying NOT NULL, "description" character varying, "order" integer NOT NULL DEFAULT '0', "parkingId" uuid NOT NULL, CONSTRAINT "PK_9d3243cf37a8a0bc34c548a82ad" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "parking_sizes" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "length" double precision, "width" double precision, "height" double precision, "parkingId" character varying NOT NULL, CONSTRAINT "PK_3c7fcb85adbdfa06bfbfcdfe959" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TYPE "public"."applied_price_rules_ruletype_enum" AS ENUM('time_based', 'day_based', 'date_based', 'duration_based', 'discount')`);
        await queryRunner.query(`CREATE TABLE "applied_price_rules" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "bookingId" uuid NOT NULL, "priceRuleId" uuid, "ruleName" character varying NOT NULL, "factor" double precision NOT NULL, "ruleType" "public"."applied_price_rules_ruletype_enum" NOT NULL, "effectOnPrice" double precision NOT NULL, CONSTRAINT "PK_3b9f3b3cd136aed1454cb4afe00" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "review_criteria" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "cleanliness" integer, "accuracy" integer, "security" integer, "communication" integer, "convenience" integer, "value" integer, "reviewId" character varying NOT NULL, CONSTRAINT "PK_b1ab66a01e71d2aed265eda3844" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "notification_data" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "data" jsonb NOT NULL DEFAULT '{}', "notificationId" character varying NOT NULL, CONSTRAINT "PK_c3665cd4b50f2a079c1fe5b0f27" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TABLE "analytics_event_data" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "data" jsonb NOT NULL DEFAULT '{}', "eventId" character varying NOT NULL, CONSTRAINT "PK_3e8312c1773cf2e375dff032938" PRIMARY KEY ("id"))`);
        await queryRunner.query(`ALTER TABLE "parkings" DROP COLUMN "size"`);
        await queryRunner.query(`ALTER TABLE "parkings" DROP COLUMN "features"`);
        await queryRunner.query(`ALTER TABLE "parkings" DROP COLUMN "photos"`);
        await queryRunner.query(`ALTER TABLE "parkings" DROP COLUMN "availability"`);
        await queryRunner.query(`ALTER TABLE "bookings" DROP COLUMN "appliedPriceRules"`);
        await queryRunner.query(`ALTER TABLE "reviews" DROP COLUMN "criteria"`);
        await queryRunner.query(`ALTER TABLE "notifications" DROP COLUMN "data"`);
        await queryRunner.query(`ALTER TABLE "analytics_events" DROP COLUMN "data"`);
        await queryRunner.query(`ALTER TABLE "availability_schedules" ADD CONSTRAINT "FK_dcf00dd92b22cf92a5064f10bb9" FOREIGN KEY ("parkingId") REFERENCES "parkings"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "availability_time_slots" ADD CONSTRAINT "FK_f1f83287eaaee25b481c1982bcc" FOREIGN KEY ("scheduleId") REFERENCES "availability_schedules"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "availability_time_slots" ADD CONSTRAINT "FK_89999274cbe49f4463fc5b88240" FOREIGN KEY ("exceptionId") REFERENCES "availability_exceptions"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "availability_exceptions" ADD CONSTRAINT "FK_e8092cc20d59faafb68fe6b43cc" FOREIGN KEY ("parkingId") REFERENCES "parkings"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "parking_features" ADD CONSTRAINT "FK_8a7764bf1f0c9e7ee2c4f92c11a" FOREIGN KEY ("parkingId") REFERENCES "parkings"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "parking_photos" ADD CONSTRAINT "FK_b038066c9d87632913e077a2a76" FOREIGN KEY ("parkingId") REFERENCES "parkings"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "applied_price_rules" ADD CONSTRAINT "FK_99daa05b697ad03f28a19956068" FOREIGN KEY ("bookingId") REFERENCES "bookings"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "applied_price_rules" ADD CONSTRAINT "FK_9d0f6f90ce6e8d62253cb30956b" FOREIGN KEY ("priceRuleId") REFERENCES "price_rules"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "applied_price_rules" DROP CONSTRAINT "FK_9d0f6f90ce6e8d62253cb30956b"`);
        await queryRunner.query(`ALTER TABLE "applied_price_rules" DROP CONSTRAINT "FK_99daa05b697ad03f28a19956068"`);
        await queryRunner.query(`ALTER TABLE "parking_photos" DROP CONSTRAINT "FK_b038066c9d87632913e077a2a76"`);
        await queryRunner.query(`ALTER TABLE "parking_features" DROP CONSTRAINT "FK_8a7764bf1f0c9e7ee2c4f92c11a"`);
        await queryRunner.query(`ALTER TABLE "availability_exceptions" DROP CONSTRAINT "FK_e8092cc20d59faafb68fe6b43cc"`);
        await queryRunner.query(`ALTER TABLE "availability_time_slots" DROP CONSTRAINT "FK_89999274cbe49f4463fc5b88240"`);
        await queryRunner.query(`ALTER TABLE "availability_time_slots" DROP CONSTRAINT "FK_f1f83287eaaee25b481c1982bcc"`);
        await queryRunner.query(`ALTER TABLE "availability_schedules" DROP CONSTRAINT "FK_dcf00dd92b22cf92a5064f10bb9"`);
        await queryRunner.query(`ALTER TABLE "analytics_events" ADD "data" jsonb NOT NULL DEFAULT '{}'`);
        await queryRunner.query(`ALTER TABLE "notifications" ADD "data" jsonb NOT NULL DEFAULT '{}'`);
        await queryRunner.query(`ALTER TABLE "reviews" ADD "criteria" jsonb`);
        await queryRunner.query(`ALTER TABLE "bookings" ADD "appliedPriceRules" jsonb`);
        await queryRunner.query(`ALTER TABLE "parkings" ADD "availability" jsonb NOT NULL`);
        await queryRunner.query(`ALTER TABLE "parkings" ADD "photos" jsonb NOT NULL DEFAULT '[]'`);
        await queryRunner.query(`ALTER TABLE "parkings" ADD "features" jsonb NOT NULL DEFAULT '[]'`);
        await queryRunner.query(`ALTER TABLE "parkings" ADD "size" jsonb NOT NULL DEFAULT '{}'`);
        await queryRunner.query(`DROP TABLE "analytics_event_data"`);
        await queryRunner.query(`DROP TABLE "notification_data"`);
        await queryRunner.query(`DROP TABLE "review_criteria"`);
        await queryRunner.query(`DROP TABLE "applied_price_rules"`);
        await queryRunner.query(`DROP TYPE "public"."applied_price_rules_ruletype_enum"`);
        await queryRunner.query(`DROP TABLE "parking_sizes"`);
        await queryRunner.query(`DROP TABLE "parking_photos"`);
        await queryRunner.query(`DROP TABLE "parking_features"`);
        await queryRunner.query(`DROP TABLE "availability_exceptions"`);
        await queryRunner.query(`DROP TABLE "availability_time_slots"`);
        await queryRunner.query(`DROP TABLE "availability_schedules"`);
        await queryRunner.query(`DROP TYPE "public"."availability_schedules_dayofweek_enum"`);
    }

}
