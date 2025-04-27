import { MigrationInterface, QueryRunner } from "typeorm";

export class Migration1745756213276 implements MigrationInterface {
    name = 'Migration1745756213276'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TYPE "public"."users_verificationlevel_enum" AS ENUM('0', '1', '2', '3', '4')`);
        await queryRunner.query(`ALTER TABLE "users" ADD "verificationLevel" "public"."users_verificationlevel_enum" NOT NULL DEFAULT '0'`);
        await queryRunner.query(`ALTER TABLE "users" ADD "emailVerificationToken" character varying`);
        await queryRunner.query(`ALTER TABLE "users" ADD "emailVerificationExpires" TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE "users" ADD "phoneVerificationCode" character varying`);
        await queryRunner.query(`ALTER TABLE "users" ADD "phoneVerificationExpires" TIMESTAMP`);
        await queryRunner.query(`ALTER TABLE "users" ADD "phoneVerified" boolean NOT NULL DEFAULT false`);
        await queryRunner.query(`ALTER TABLE "users" ADD "idDocumentFront" character varying`);
        await queryRunner.query(`ALTER TABLE "users" ADD "idDocumentBack" character varying`);
        await queryRunner.query(`ALTER TABLE "users" ADD "addressProofDocument" character varying`);
        await queryRunner.query(`ALTER TABLE "users" ADD "selfieImage" character varying`);
        await queryRunner.query(`ALTER TABLE "users" ADD "verificationNotes" text`);
        await queryRunner.query(`ALTER TABLE "users" ADD "idVerified" boolean NOT NULL DEFAULT false`);
        await queryRunner.query(`ALTER TABLE "users" ADD "advancedVerified" boolean NOT NULL DEFAULT false`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "advancedVerified"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "idVerified"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "verificationNotes"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "selfieImage"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "addressProofDocument"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "idDocumentBack"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "idDocumentFront"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "phoneVerified"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "phoneVerificationExpires"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "phoneVerificationCode"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "emailVerificationExpires"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "emailVerificationToken"`);
        await queryRunner.query(`ALTER TABLE "users" DROP COLUMN "verificationLevel"`);
        await queryRunner.query(`DROP TYPE "public"."users_verificationlevel_enum"`);
    }

}
