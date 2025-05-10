import { MigrationInterface, QueryRunner } from "typeorm";

export class Migration1746119804932 implements MigrationInterface {
    name = 'Migration1746119804932'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TABLE "subscription_pauses" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "subscriptionId" uuid NOT NULL, "startDate" TIMESTAMP NOT NULL, "endDate" TIMESTAMP NOT NULL, "reason" text, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "PK_a0e990d760831f849bbf5db66b7" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TYPE "public"."subscription_sharings_status_enum" AS ENUM('pending', 'accepted', 'rejected', 'revoked')`);
        await queryRunner.query(`CREATE TABLE "subscription_sharings" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "subscriptionId" uuid NOT NULL, "sharedWithUserId" uuid NOT NULL, "status" "public"."subscription_sharings_status_enum" NOT NULL DEFAULT 'pending', "validUntil" TIMESTAMP, "allowedDays" integer array, "startTime" character varying, "endTime" character varying, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "PK_5e72bdf388c27168e18d81f327f" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TYPE "public"."subscriptions_status_enum" AS ENUM('active', 'paused', 'cancelled', 'expired')`);
        await queryRunner.query(`CREATE TABLE "subscriptions" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "userId" uuid NOT NULL, "parkingId" uuid NOT NULL, "planId" uuid NOT NULL, "status" "public"."subscriptions_status_enum" NOT NULL DEFAULT 'active', "startDate" TIMESTAMP NOT NULL, "endDate" TIMESTAMP NOT NULL, "pricePerPeriod" double precision NOT NULL, "autoRenew" boolean NOT NULL DEFAULT false, "pausesUsed" integer NOT NULL DEFAULT '0', "pausesRemaining" integer NOT NULL DEFAULT '0', "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "PK_a87248d73155605cf782be9ee5e" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TYPE "public"."subscription_plans_type_enum" AS ENUM('hourly', 'daily', 'weekly', 'monthly', 'custom')`);
        await queryRunner.query(`CREATE TYPE "public"."subscription_plans_recurrence_enum" AS ENUM('none', 'daily', 'weekday', 'weekend', 'weekly', 'biweekly', 'monthly')`);
        await queryRunner.query(`CREATE TABLE "subscription_plans" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "name" character varying NOT NULL, "description" text NOT NULL, "type" "public"."subscription_plans_type_enum" NOT NULL DEFAULT 'monthly', "duration" integer NOT NULL, "recurrence" "public"."subscription_plans_recurrence_enum", "allowedDays" integer array, "startTime" character varying, "endTime" character varying, "discountPercentage" double precision NOT NULL, "isActive" boolean NOT NULL DEFAULT true, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "PK_9ab8fe6918451ab3d0a4fb6bb0c" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE TYPE "public"."swap_offers_status_enum" AS ENUM('pending', 'accepted', 'rejected', 'cancelled', 'completed')`);
        await queryRunner.query(`CREATE TABLE "swap_offers" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "listingId" uuid NOT NULL, "userId" uuid NOT NULL, "offerParkingId" uuid, "status" "public"."swap_offers_status_enum" NOT NULL DEFAULT 'pending', "startDate" TIMESTAMP, "endDate" TIMESTAMP, "offerPrice" double precision, "message" text, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "PK_440e9b1ae20bccd80c56bb231da" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE INDEX "IDX_eea7ceab13370ba8dc1c582d21" ON "swap_offers" ("listingId") `);
        await queryRunner.query(`CREATE INDEX "IDX_3c3a080cb2f08fa78fb7102ac6" ON "swap_offers" ("status") `);
        await queryRunner.query(`CREATE TYPE "public"."swap_listings_status_enum" AS ENUM('active', 'booked', 'completed', 'cancelled', 'expired')`);
        await queryRunner.query(`CREATE TABLE "swap_listings" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "userId" uuid NOT NULL, "parkingId" uuid NOT NULL, "subscriptionId" uuid, "startDate" TIMESTAMP NOT NULL, "endDate" TIMESTAMP NOT NULL, "description" text NOT NULL, "status" "public"."swap_listings_status_enum" NOT NULL DEFAULT 'active', "requiresExchange" boolean NOT NULL DEFAULT false, "preferredLocationLat" integer, "preferredLocationLng" integer, "preferredLocationRadius" integer, "price" double precision, "allowPartialDays" boolean NOT NULL DEFAULT false, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "PK_8d69c733950a00c9630c3f77521" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE INDEX "IDX_361c66c29dac42a8109d5eef66" ON "swap_listings" ("startDate") `);
        await queryRunner.query(`CREATE INDEX "IDX_c724f444aa72ddfec25d789ca2" ON "swap_listings" ("endDate") `);
        await queryRunner.query(`CREATE INDEX "IDX_56e85ecc037012d6079ce5bf7f" ON "swap_listings" ("status") `);
        await queryRunner.query(`CREATE TYPE "public"."swap_transactions_status_enum" AS ENUM('pending', 'completed', 'failed', 'refunded')`);
        await queryRunner.query(`CREATE TABLE "swap_transactions" ("id" uuid NOT NULL DEFAULT uuid_generate_v4(), "listingId" uuid NOT NULL, "offerId" uuid NOT NULL, "listingOwnerId" uuid NOT NULL, "offerOwnerId" uuid NOT NULL, "amount" double precision NOT NULL, "platformFee" double precision NOT NULL DEFAULT '0', "taxAmount" double precision NOT NULL DEFAULT '0', "status" "public"."swap_transactions_status_enum" NOT NULL DEFAULT 'pending', "paymentIntentId" character varying, "refundId" character varying, "createdAt" TIMESTAMP NOT NULL DEFAULT now(), "updatedAt" TIMESTAMP NOT NULL DEFAULT now(), CONSTRAINT "PK_1aa502020ff2dcb5a6628e087cb" PRIMARY KEY ("id"))`);
        await queryRunner.query(`CREATE INDEX "IDX_1545d0875887aac6719a1de00c" ON "swap_transactions" ("listingId") `);
        await queryRunner.query(`CREATE INDEX "IDX_d29e2a77809d26f75eea64da0a" ON "swap_transactions" ("offerId") `);
        await queryRunner.query(`CREATE INDEX "IDX_6e2bd18fbc380dcfdb31c51b8b" ON "swap_transactions" ("status") `);
        await queryRunner.query(`ALTER TABLE "subscription_pauses" ADD CONSTRAINT "FK_457d6d1e8db22b291c6cc7526c3" FOREIGN KEY ("subscriptionId") REFERENCES "subscriptions"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "subscription_sharings" ADD CONSTRAINT "FK_7447aa75f60b903896808113d7c" FOREIGN KEY ("subscriptionId") REFERENCES "subscriptions"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "subscription_sharings" ADD CONSTRAINT "FK_30c39605323172b6450a2a7b876" FOREIGN KEY ("sharedWithUserId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "subscriptions" ADD CONSTRAINT "FK_fbdba4e2ac694cf8c9cecf4dc84" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "subscriptions" ADD CONSTRAINT "FK_7ddc1d7c1bd0b30f7375df16992" FOREIGN KEY ("parkingId") REFERENCES "parkings"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "subscriptions" ADD CONSTRAINT "FK_7536cba909dd7584a4640cad7d5" FOREIGN KEY ("planId") REFERENCES "subscription_plans"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "swap_offers" ADD CONSTRAINT "FK_eea7ceab13370ba8dc1c582d216" FOREIGN KEY ("listingId") REFERENCES "swap_listings"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "swap_offers" ADD CONSTRAINT "FK_e0cc535da08ae541c02583fc287" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "swap_offers" ADD CONSTRAINT "FK_8e4e43312c6fcc5b3014467e622" FOREIGN KEY ("offerParkingId") REFERENCES "parkings"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "swap_listings" ADD CONSTRAINT "FK_7574d8f8afcfb8b6442c9b37d2e" FOREIGN KEY ("userId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "swap_listings" ADD CONSTRAINT "FK_4c630d7bc9c6e2cebb44488cbb7" FOREIGN KEY ("parkingId") REFERENCES "parkings"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "swap_listings" ADD CONSTRAINT "FK_4b74f9338ce62163317cf126c69" FOREIGN KEY ("subscriptionId") REFERENCES "subscriptions"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "swap_transactions" ADD CONSTRAINT "FK_1545d0875887aac6719a1de00c6" FOREIGN KEY ("listingId") REFERENCES "swap_listings"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "swap_transactions" ADD CONSTRAINT "FK_d29e2a77809d26f75eea64da0a8" FOREIGN KEY ("offerId") REFERENCES "swap_offers"("id") ON DELETE CASCADE ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "swap_transactions" ADD CONSTRAINT "FK_e3b2131dbf1d9c0402bb93a11d2" FOREIGN KEY ("listingOwnerId") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
        await queryRunner.query(`ALTER TABLE "swap_transactions" ADD CONSTRAINT "FK_b03f592c6a87211f1f6e1d48a1a" FOREIGN KEY ("offerOwnerId") REFERENCES "users"("id") ON DELETE NO ACTION ON UPDATE NO ACTION`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "swap_transactions" DROP CONSTRAINT "FK_b03f592c6a87211f1f6e1d48a1a"`);
        await queryRunner.query(`ALTER TABLE "swap_transactions" DROP CONSTRAINT "FK_e3b2131dbf1d9c0402bb93a11d2"`);
        await queryRunner.query(`ALTER TABLE "swap_transactions" DROP CONSTRAINT "FK_d29e2a77809d26f75eea64da0a8"`);
        await queryRunner.query(`ALTER TABLE "swap_transactions" DROP CONSTRAINT "FK_1545d0875887aac6719a1de00c6"`);
        await queryRunner.query(`ALTER TABLE "swap_listings" DROP CONSTRAINT "FK_4b74f9338ce62163317cf126c69"`);
        await queryRunner.query(`ALTER TABLE "swap_listings" DROP CONSTRAINT "FK_4c630d7bc9c6e2cebb44488cbb7"`);
        await queryRunner.query(`ALTER TABLE "swap_listings" DROP CONSTRAINT "FK_7574d8f8afcfb8b6442c9b37d2e"`);
        await queryRunner.query(`ALTER TABLE "swap_offers" DROP CONSTRAINT "FK_8e4e43312c6fcc5b3014467e622"`);
        await queryRunner.query(`ALTER TABLE "swap_offers" DROP CONSTRAINT "FK_e0cc535da08ae541c02583fc287"`);
        await queryRunner.query(`ALTER TABLE "swap_offers" DROP CONSTRAINT "FK_eea7ceab13370ba8dc1c582d216"`);
        await queryRunner.query(`ALTER TABLE "subscriptions" DROP CONSTRAINT "FK_7536cba909dd7584a4640cad7d5"`);
        await queryRunner.query(`ALTER TABLE "subscriptions" DROP CONSTRAINT "FK_7ddc1d7c1bd0b30f7375df16992"`);
        await queryRunner.query(`ALTER TABLE "subscriptions" DROP CONSTRAINT "FK_fbdba4e2ac694cf8c9cecf4dc84"`);
        await queryRunner.query(`ALTER TABLE "subscription_sharings" DROP CONSTRAINT "FK_30c39605323172b6450a2a7b876"`);
        await queryRunner.query(`ALTER TABLE "subscription_sharings" DROP CONSTRAINT "FK_7447aa75f60b903896808113d7c"`);
        await queryRunner.query(`ALTER TABLE "subscription_pauses" DROP CONSTRAINT "FK_457d6d1e8db22b291c6cc7526c3"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_6e2bd18fbc380dcfdb31c51b8b"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_d29e2a77809d26f75eea64da0a"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_1545d0875887aac6719a1de00c"`);
        await queryRunner.query(`DROP TABLE "swap_transactions"`);
        await queryRunner.query(`DROP TYPE "public"."swap_transactions_status_enum"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_56e85ecc037012d6079ce5bf7f"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_c724f444aa72ddfec25d789ca2"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_361c66c29dac42a8109d5eef66"`);
        await queryRunner.query(`DROP TABLE "swap_listings"`);
        await queryRunner.query(`DROP TYPE "public"."swap_listings_status_enum"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_3c3a080cb2f08fa78fb7102ac6"`);
        await queryRunner.query(`DROP INDEX "public"."IDX_eea7ceab13370ba8dc1c582d21"`);
        await queryRunner.query(`DROP TABLE "swap_offers"`);
        await queryRunner.query(`DROP TYPE "public"."swap_offers_status_enum"`);
        await queryRunner.query(`DROP TABLE "subscription_plans"`);
        await queryRunner.query(`DROP TYPE "public"."subscription_plans_recurrence_enum"`);
        await queryRunner.query(`DROP TYPE "public"."subscription_plans_type_enum"`);
        await queryRunner.query(`DROP TABLE "subscriptions"`);
        await queryRunner.query(`DROP TYPE "public"."subscriptions_status_enum"`);
        await queryRunner.query(`DROP TABLE "subscription_sharings"`);
        await queryRunner.query(`DROP TYPE "public"."subscription_sharings_status_enum"`);
        await queryRunner.query(`DROP TABLE "subscription_pauses"`);
    }

}
