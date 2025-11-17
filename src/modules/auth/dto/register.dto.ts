import { ApiProperty } from '@nestjs/swagger';
import {
  IsEmail,
  IsNotEmpty,
  IsString,
  MinLength,
  MaxLength,
  Matches,
  IsOptional,
} from 'class-validator';
import { SECURITY } from '../../../core/constants/business-rules.constants';

export class RegisterDto {
  @ApiProperty({
    example: 'john.doe@example.com',
    description: 'User email address',
  })
  @IsEmail({}, { message: 'Please provide a valid email address' })
  @IsNotEmpty({ message: 'Email is required' })
  email: string;

  @ApiProperty({
    example: 'MyS3cur3P@ssw0rd',
    description:
      'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character',
    minLength: SECURITY.MIN_PASSWORD_LENGTH,
    maxLength: SECURITY.MAX_PASSWORD_LENGTH,
  })
  @IsString()
  @MinLength(SECURITY.MIN_PASSWORD_LENGTH, {
    message: `Password must be at least ${SECURITY.MIN_PASSWORD_LENGTH} characters long`,
  })
  @MaxLength(SECURITY.MAX_PASSWORD_LENGTH, {
    message: `Password must not exceed ${SECURITY.MAX_PASSWORD_LENGTH} characters`,
  })
  @Matches(SECURITY.PASSWORD_REGEX, {
    message:
      'Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character (@$!%*?&)',
  })
  @IsNotEmpty({ message: 'Password is required' })
  password: string;

  @ApiProperty({
    example: 'John',
    description: 'User first name',
    minLength: 2,
    maxLength: 50,
  })
  @IsString()
  @MinLength(2, { message: 'First name must be at least 2 characters long' })
  @MaxLength(50, { message: 'First name must not exceed 50 characters' })
  @IsNotEmpty({ message: 'First name is required' })
  firstName: string;

  @ApiProperty({
    example: 'Doe',
    description: 'User last name',
    minLength: 2,
    maxLength: 50,
  })
  @IsString()
  @MinLength(2, { message: 'Last name must be at least 2 characters long' })
  @MaxLength(50, { message: 'Last name must not exceed 50 characters' })
  @IsNotEmpty({ message: 'Last name is required' })
  lastName: string;

  @ApiProperty({
    example: '+33612345678',
    description: 'User phone number in international format',
    required: false,
  })
  @IsOptional()
  @IsString()
  @Matches(/^\+[1-9]\d{1,14}$/, {
    message: 'Phone number must be in international format (e.g., +33612345678)',
  })
  phone?: string;
}